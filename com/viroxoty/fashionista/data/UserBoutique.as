// Decompiled by AS3 Sorcerer 1.78
// http://www.as3sorcerer.com/

//com.viroxoty.fashionista.data.UserBoutique

package com.viroxoty.fashionista.data{
    import __AS3__.vec.Vector;
    import __AS3__.vec.*;
    import com.viroxoty.fashionista.util.*;

    public class UserBoutique {

        public var id:int;
        public var active:Boolean;
        public var user_id:String;
        public var username:String;
        public var floors:Vector.<UserBoutiqueFloor>;
        public var decors:Object;
        public var visits:int;
        public var daily_visits:int;
        public var entry_floor:int;
        public var visited:Boolean;
        public var firstVisitAnyBoutique:Boolean;

        public static function get_starting_boutique():UserBoutique{
            var _local1:UserBoutique = new (UserBoutique)();
            _local1.floors = new Vector.<UserBoutiqueFloor>(2);
            _local1.floors[0] = null;
            _local1.floors[1] = new UserBoutiqueFloor();
            Tracer.out(("UserBoutique > get_starting_boutique: ub.floors[1] is " + _local1.floors[1]));
            return (_local1);
        }
        public static function sortModelsByZPos(models:Vector.<UserBoutiqueModel>){
            var z_sort:Function;
            var i:int;
            z_sort = function (_arg1:UserBoutiqueModel, _arg2:UserBoutiqueModel){
                if (_arg1.z_pos < _arg2.z_pos)
                {
                    return (-1);
                };
                return (1);
            };
            models.sort(z_sort);
            var l:int = models.length;
            while (i < l)
            {
                models[i].z_pos = i;
                i = (i + 1);
            };
        }

        public function get floorCount():int{
            return ((this.floors.length - 1));
        }
        public function parseServerData(_arg1:Object, _arg2:int=0):void{
            var _local3:int;
            var _local4:Object;
            var _local5:Decor;
            var _local6:UserDecor;
            var _local7:int;
            var _local8:UserBoutiqueFloor;
            this.visited = _arg1.visited;
            this.firstVisitAnyBoutique = _arg1.firstVisitAnyBoutique;
            var _local9:Object = _arg1.boutique;
            this.id = _local9.id;
            this.user_id = _local9.user_id;
            this.active = (_local9.active == "1");
            this.visits = _local9.visits;
            this.daily_visits = _local9.daily_visits;
            this.entry_floor = _local9.entry_floor;
            if (_arg2 == 0)
            {
                _arg2 = this.entry_floor;
            };
            var _local10:int = _local9.floors;
            this.floors = new Vector.<UserBoutiqueFloor>((_local10 + 1));
            this.floors[0] = null;
            this.floors[_arg2] = new UserBoutiqueFloor();
            Tracer.out((("UserBoutique > parseServerData : " + this.floorCount) + " floors setup"));
            this.decors = {};
            if (_local9.decor)
            {
                _local10 = _local9.decor.length;
                _local3 = 0;
                while (_local3 < _local10)
                {
                    _local4 = _local9.decor[_local3];
                    if (this.decors[_local4.decorId] != null)
                    {
                        _local5 = this.decors[_local4.decorId];
                    } else
                    {
                        _local5 = Decor.parseServerData(_local4);
                        this.decors[_local5.id] = _local5;
                    };
                    _local6 = UserDecor.parseServerData(_local4);
                    _local5.addInstance(_local6);
                    _local7 = _local6.floor;
                    if (_local7 > 0)
                    {
                        _local8 = this.floors[_local7];
                        _local8.userDecors.push(_local6);
                    };
                    _local3++;
                };
            };
            this.addModelDataForFloor(_local9.models, this.floors[_arg2], _arg2);
        }
        public function add_floor_data(_arg1:Object, _arg2:int){
            var _local3:int;
            var _local4:int;
            var _local5:Object;
            var _local6:Decor;
            var _local7:UserDecor;
            var _local8:int;
            if (this.floors[_arg2] == null)
            {
                this.floors[_arg2] = new UserBoutiqueFloor();
            };
            var _local9:UserBoutiqueFloor = this.floors[_arg2];
            if (_arg1.decor)
            {
                _local3 = _arg1.decor.length;
                _local4 = 0;
                while (_local4 < _local3)
                {
                    _local5 = _arg1.decor[_local4];
                    if (this.decors[_local5.decorId] != null)
                    {
                        _local6 = this.decors[_local5.decorId];
                    } else
                    {
                        _local6 = Decor.parseServerData(_local5);
                        this.decors[_local6.id] = _local6;
                    };
                    _local7 = UserDecor.parseServerData(_local5);
                    _local6.addInstance(_local7);
                    _local8 = _local7.floor;
                    if (_local8 == _arg2)
                    {
                        _local9.userDecors.push(_local7);
                    } else
                    {
                        Tracer.out("UserBoutique > add_floor_data: ERROR userDecor floor does not match expected level");
                    };
                    _local4++;
                };
            };
            this.addModelDataForFloor(_arg1.models, _local9, _arg2);
        }
        public function floor_loaded(_arg1:int):Boolean{
            Tracer.out(((("UserBoutique > floor_loaded: floors[" + _arg1) + "] is ") + this.floors[_arg1]));
            return (!((this.floors[_arg1] == null)));
        }
        public function get_decor_for_floor(_arg1:int):Array{
            var _local2:Array = this.floors[_arg1].userDecors;
            _local2.sortOn("z_pos", Array.NUMERIC);
            return (_local2);
        }
        public function add_decor_to_floor(_arg1:UserDecor){
            var _local2:int = _arg1.floor;
            var _local3:UserBoutiqueFloor = this.floors[_local2];
            _local3.userDecors.push(_arg1);
        }
        public function remove_decor_from_floor(_arg1:UserDecor){
            var _local5:int;
            var _local2:int = _arg1.floor;
            var _local3:Array = this.floors[_local2].userDecors;
            var _local4:int = _local3.length;
            while (_local5 < _local4)
            {
                if (_local3[_local5] == _arg1)
                {
                    _local3.splice(_local5, 1);
                    break;
                };
                _local5++;
            };
            _arg1.floor = 0;
        }
        public function get_models_for_floor(_arg1:int):Vector.<UserBoutiqueModel>{
            sortModelsByZPos(this.floors[_arg1].models);
            return (this.floors[_arg1].models);
        }
        public function add_model(_arg1:int):void{
            var _local2:UserBoutiqueModel = new UserBoutiqueModel();
            _local2.floor = _arg1;
            this.floors[_arg1].models.push(_local2);
        }
        public function add_floor(){
            var _local1:int = this.floorCount;
            this.floors[(_local1 + 1)] = new UserBoutiqueFloor();
            var _local2:UserBoutiqueModel = new UserBoutiqueModel();
            _local2.floor = this.floorCount;
            this.floors[this.floorCount].model = _local2;
        }
        public function update_model(_arg1:UserBoutiqueModel):void{
            var _local2:UserBoutiqueFloor;
            if (_arg1 != null)
            {
                Tracer.out(("update_model: model is " + _arg1));
                _local2 = this.floors[_arg1.floor];
                Tracer.out(("update_model: floor is " + _local2));
                if (_local2 != null)
                {
                    _local2.check_add_model(_arg1);
                };
            };
        }
        function addModelDataForFloor(_arg1:Array, _arg2:UserBoutiqueFloor, _arg3:int){
            var _local4:int;
            var _local5:int;
            var _local6:UserBoutiqueModel;
            _arg2.models = new Vector.<UserBoutiqueModel>();
            var _local7:Vector.<UserBoutiqueModel> = _arg2.models;
            if (_arg1.length > 0)
            {
                _local4 = 0;
                _local5 = _arg1.length;
                while (_local4 < _local5)
                {
                    _local6 = UserBoutiqueModel.parseServerData(_arg1[_local4]);
                    _local7.push(_local6);
                    _local4++;
                };
            } else
            {
                _local6 = new UserBoutiqueModel();
                _local6.floor = _arg3;
                _local7.push(_local6);
            };
            sortModelsByZPos(_local7);
        }

    }
}//package com.viroxoty.fashionista.data

