// Decompiled by AS3 Sorcerer 1.78
// http://www.as3sorcerer.com/

//com.viroxoty.fashionista.data.Album

package com.viroxoty.fashionista.data{
    public class Album {

        public static const TYPE_MY_LOOKS:String = "my_looks";
        public static const TYPE_LOOKS:String = "looks";
        public static const TYPE_MY_BOUTIQUE:String = "my_boutique";
        public static const TYPE_BOUTIQUES:String = "boutiques";

        static var names:Object = {
            "my_looks":"My Fashionista FaceOff Looks",
            "looks":"My Favorite Fashionista FaceOff Looks",
            "my_boutique":"My Fashionista FaceOff Boutique",
            "boutiques":"My Favorite Fashionista FaceOff Boutiques"
        };
        static var descriptions:Object = {
            "my_looks":"My Fashionista FaceOff Looks",
            "looks":"My Favorite Fashionista FaceOff Looks",
            "my_boutique":"My Fashionista FaceOff Boutique",
            "boutiques":"My Favorite Fashionista FaceOff Boutiques"
        };

        public var id:String;
        public var type:String;

        public function Album(_arg1:String=null, _arg2:String=null){
            if (_arg1)
            {
                this.type = _arg1;
            };
            if (_arg2)
            {
                this.id = _arg2;
            };
        }
        public static function nameForType(_arg1:String){
            return (names[_arg1]);
        }
        public static function descriptionForType(_arg1:String){
            return (descriptions[_arg1]);
        }

    }
}//package com.viroxoty.fashionista.data

