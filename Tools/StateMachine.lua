StateMachine = {}
StateMachine.__index = StateMachine

StateMachine.new = function()
    local new = {}

    new.states  = {}
    new.current = nil

    setmetatable( new, StateMachine )
    return new
end

StateMachine.getCurrentState = function( self )
    if not self.current then return nil end
    return self.states[ self.current ]
end

StateMachine.update = function( self, dt )
    local state = self:getCurrentState()
    if state and state.update then
        state:update( dt )
    end
end

StateMachine.draw = function( self )
    local state = self:getCurrentState()
    if state and state.draw then
        state:draw()
    end
end

StateMachine.addState = function( self, stateId )
    if stateId then
        self.states[ stateId  ] = {
            sm = self
        }
        return self.states[ stateId ]
    end
end

StateMachine.setState = function( self, stateId )
    if not self.states[ stateId ] then return end

    local state = self:getCurrentState()
    if state and state.exit then
        state:exit()
    end

    self.current = stateId
    state = self:getCurrentState()
    if state.enter then
        state:enter()
    end
end