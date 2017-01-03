// Decompiled by AS3 Sorcerer 1.78
// http://www.as3sorcerer.com/

//com.viroxoty.fashionista.data.UserBoutiqueFloor

package com.viroxoty.fashionista.data{
    import __AS3__.vec.Vector;
    import __AS3__.vec.*;

    public class UserBoutiqueFloor {

        public var userDecors:Array;
        public var models:Vector.<UserBoutiqueModel>;

        public function UserBoutiqueFloor(){
            this.userDecors = [];
            super();
            this.models = new Vector.<UserBoutiqueModel>();
        }
        public function toString():String{
            return ((("userDecors:[" + this.userDecors) + "]"));
        }
        public function check_add_model(_arg1:UserBoutiqueModel){
            if (this.models.indexOf(_arg1) == -1)
            {
                this.models.push(_arg1);
            };
        }
        public function get model():UserBoutiqueModel{
            return (this.models[0]);
        }
        public function set model(_arg1:UserBoutiqueModel):void{
            this.models[0] = _arg1;
        }
        public function get second_model():UserBoutiqueModel{
            return (this.models[1]);
        }
        public function set second_model(_arg1:UserBoutiqueModel):void{
            this.models[1] = _arg1;
        }
        public function get both_models_visible():Boolean{
            return (((((this.models[0].placed) && ((this.models.length > 1)))) && (this.models[1].placed)));
        }

    }
}//package com.viroxoty.fashionista.data

