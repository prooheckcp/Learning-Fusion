local RunService = game:GetService("RunService")

local State = require(script.State)
local Transition = require(script.Transition)
local Signal = require(script.Signal)
local Copy = require(script.Copy)

local DUPLICATE_ERROR: string = "There cannot be more than 1 state by the same name"

--[=[
    @class StateMachine

    State Machines consist of state managers that dictate at which state does an object currently meet at.
    It allows us to easily manage what should an object do at each given state and when/how it should change
    between them
]=]
local StateMachine = {}
StateMachine.__index = StateMachine
StateMachine.StateChanged = nil :: Signal.Signal<string>?
StateMachine.State = State
StateMachine.Transition = Transition

function StateMachine.new(initialState: string, states: {State.State}, initialData: {[string]: any}?): StateMachine
    local self = setmetatable({}, StateMachine)
    
    self._CustomData = initialData or {} :: {[string]: any}
    self._States = {} :: {[string]: State.State}
    self.StateChanged = Signal.new() :: Signal.Signal<string>

    for _, state: State.State in states do -- Load the states
        if self._States[state.Name] then
            error(DUPLICATE_ERROR.." ,"..state.Name, 2)
        end

        local stateClone: State.State = Copy(state)
        
        stateClone:OnInit(self._CustomData)
        self._States[state.Name] = stateClone
    end

    self.heartBeat = RunService.Heartbeat:Connect(function(deltaTime: number)
        self:_CheckTransitions(true)
        
        local state: State.State? = self:_GetCurrentStateObject()
        
        if not state or getmetatable(state).OnHearBeat == state.OnHearBeat then
            return
        end

        state:OnHearBeat(self._CustomData, deltaTime)
    end)

    self:_ChangeState(initialState)

    return self
end

--[=[
    Returns the current state of the State Machine

    @return string
]=]
function StateMachine:GetCurrentState(): string
    return self._CurrentState
end

--[=[
    Changing data request

    @param index string
    @param newValue any

    @return ()
]=]
function StateMachine:ChangeData(index: string, newValue: any): ()
    if self._CustomData[index] == newValue then
        return
    end

    self._CustomData[index] = newValue

    self:_CheckTransitions(false)
end

--[=[
    Gets the custom data
]=]
function StateMachine:GetData(): {[string]: any}
    return self._CustomData
end

--[=[
    Used to load thru a directory

    @param directory Instance

    @return {any}
]=]
function StateMachine:LoadDirectory(directory: Instance): {any}
    local loadedFiles = {}

    for _, child: Instance in directory:GetChildren() do
        if not child:IsA("ModuleScript") then
            continue
        end
        
        local success: boolean, result: any = pcall(function()
            return require(child)
        end)

        if success then
            table.insert(loadedFiles, result)
        end
    end

    return loadedFiles
end

function StateMachine:Destroy(): ()
    local state: State.State? = self:_GetCurrentStateObject()

    if state then
        state:OnLeave(self._CustomData)
    end

    if self.heartBeat then
        self.heartBeat:Disconnect()
        self.heartBeat = nil
    end
end

--[=[
    Called to change the current state of the state machine

    @private

    @param newState string

    @return ()
]=]
function StateMachine:_ChangeState(newState: string): ()
    local previousState: State.State? = self:_GetCurrentStateObject()
    local state: State.State? = self._States[newState]

    if not state then
        return
    end

    if previousState then
        previousState:OnLeave(self._CustomData)
    end

    state:OnEnter(self._CustomData)
    self._CurrentState = newState
    self.StateChanged:Fire(newState)
end

--[=[
    Gets the current state object of the state machine

    @private

    @return State
]=]
function StateMachine:_GetCurrentStateObject(): State.State?
    return self._States[self:GetCurrentState()]
end

--[=[
    Checks if we meet any condition to change the current state

    @return ()
]=]
function StateMachine:_CheckTransitions(fromHeartbeat: boolean): ()
    for _, transition: Transition.Transition in self:_GetCurrentStateObject().Transitions do
        if fromHeartbeat and not transition.OnHearbeat then
            continue
        end

        if transition:CanChangeState(self._CustomData) and transition:OnDataChanged(self._CustomData) then
            self:_ChangeState(transition.TargetState)
            break
        end
    end    
end

export type StateMachine = typeof(StateMachine.new(...))

return StateMachine