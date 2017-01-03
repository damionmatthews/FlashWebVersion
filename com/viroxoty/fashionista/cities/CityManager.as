// Decompiled by AS3 Sorcerer 1.78
// http://www.as3sorcerer.com/

//com.viroxoty.fashionista.cities.CityManager

package com.viroxoty.fashionista.cities{
    import flash.events.EventDispatcher;
    import com.viroxoty.fashionista.boutique.BoutiqueDataObject;
    import com.viroxoty.fashionista.*;
    import flash.events.*;
    import com.viroxoty.fashionista.boutique.*;
    import com.viroxoty.fashionista.asset.*;
    import com.viroxoty.fashionista.util.*;

    public class CityManager extends EventDispatcher {

        private static var _instance:CityManager;

        public var num_cities:int;
        public var cities:Array;
        public var boutiques:Array;
        public var current_city:int = 1;

        public function CityManager(){
            Tracer.out("new CityManager");
            this.cities = new Array(2);
            this.boutiques = [];
            DataManager.getInstance().get_cities_data(this.loaded_cities_data);
        }
        public static function getInstance():CityManager{
            if (_instance == null)
            {
                _instance = new (CityManager)();
            };
            return (_instance);
        }

        public function loaded_cities_data(_arg1:XML):void{
            var _local2:XML;
            var _local3:CityDataObject;
            var _local4:Array;
            var _local5:int;
            var _local6:int;
            var _local7:BoutiqueDataObject;
            var _local8:XML;
            var _local9:int;
            this.num_cities = _arg1.children().length();
            while (_local9 < this.num_cities)
            {
                _local2 = _arg1.CITY[_local9];
                _local3 = new CityDataObject();
                _local3.id = int(_local2.@ID);
                _local3.name = _local2.NAME;
                _local3.level = int(_local2.LEVEL);
                _local3.points = int(_local2.POINTS);
                _local3.music = _local2.MUSIC;
                _local4 = [];
                _local5 = _local2.BOUTIQUES.children().length();
                _local6 = 0;
                while (_local6 < _local5)
                {
                    _local7 = new BoutiqueDataObject();
                    _local8 = _local2.BOUTIQUES.BOUTIQUE[_local6];
                    _local7.id = int(_local8.@ID);
                    _local7.name = _local8.NAME;
                    _local7.order = _local8.ORDER;
                    _local7.level = int(_local8.LEVEL);
                    _local7.mini_level = (((_local8.MINILEVEL)=="") ? -1 : int(_local8.MINILEVEL));
                    _local7.short_name = _local8.SHORT_NAME;
                    _local7.city_id = _local3.id;
                    _local7.isOpen = (_local8.IS_OPEN == "1");
                    _local4.push(_local7);
                    this.boutiques.push(_local7);
                    _local6++;
                };
                _local3.boutiques = _local4;
                this.cities[_local3.id] = _local3;
                _local9++;
            };
            this.boutiques.sortOn("order", Array.NUMERIC);
            var _local10:int = this.cities[0].boutiques.length;
            _local9 = 0;
            while (_local9 < _local10)
            {
                _local7 = this.cities[0].boutiques[_local9];
                _local6 = 1;
                while (_local6 < this.num_cities)
                {
                    this.cities[_local6].boutiques.push(_local7);
                    _local6++;
                };
                _local9++;
            };
            Tracer.out(("total cities: " + this.num_cities));
            Tracer.out(("total boutiques: " + this.boutiques.length));
            dispatchEvent(new Event("data_received"));
        }
        public function get_city_music(_arg1:int):String{
            return (this.cities[_arg1].music);
        }
        public function get_city_name(_arg1:int):String{
            return (this.cities[_arg1].name);
        }
        public function get_current_city_name():String{
            return (this.cities[this.current_city].name);
        }
        public function goto_city(_arg1:int):void{
            this.current_city = _arg1;
            if (_arg1 == 1)
            {
                CityNewYork.getInstance().load();
            } else
            {
                if (_arg1 == 2)
                {
                    CityParis.getInstance().load();
                };
            };
        }
        public function check_paris():void{
            if (UserData.getInstance().level >= this.cities[2].level)
            {
                this.current_city = 2;
                CityParis.getInstance().load_zoom();
            } else
            {
                if (UserData.getInstance().first_time_visit())
                {
                    Pop_Up.getInstance().display_popup(Pop_Up.LEVEL_TOO_LOW_FIRST_TIME, "paris", {"level":2});
                } else
                {
                    Pop_Up.getInstance().display_popup(Pop_Up.PARIS_LEVEL_LOW);
                };
            };
        }
        public function goto_last_city():void{
            this.goto_city(this.current_city);
        }

    }
}//package com.viroxoty.fashionista.cities

