// Decompiled by AS3 Sorcerer 1.78
// http://www.as3sorcerer.com/

//com.viroxoty.fashionista.events.GameEvent

package com.viroxoty.fashionista.events{
    import flash.events.Event;

    public class GameEvent extends Event {

        public var code:String;
        public var data:Object;

        public function GameEvent(_arg1:String, _arg2:Object=null){
            super(Events.GAME_EVENT);
            this.code = _arg1;
            this.data = _arg2;
        }
        override public function clone():Event{
            return (new GameEvent(this.code, this.data));
        }

    }
}//package com.viroxoty.fashionista.events

