// Decompiled by AS3 Sorcerer 1.78
// http://www.as3sorcerer.com/

//com.adobe.serialization.json.JSONToken

package com.adobe.serialization.json{
    public final class JSONToken {

        static const token:JSONToken = new (JSONToken)();

        public var type:int;
        public var value:Object;

        public function JSONToken(_arg1:int=-1, _arg2:Object=null){
            this.type = _arg1;
            this.value = _arg2;
        }
        static function create(_arg1:int=-1, _arg2:Object=null):JSONToken{
            token.type = _arg1;
            token.value = _arg2;
            return (token);
        }

    }
}//package com.adobe.serialization.json

