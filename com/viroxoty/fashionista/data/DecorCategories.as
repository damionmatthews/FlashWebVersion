// Decompiled by AS3 Sorcerer 1.78
// http://www.as3sorcerer.com/

//com.viroxoty.fashionista.data.DecorCategories

package com.viroxoty.fashionista.data{
    public class DecorCategories {

        public static const WALLS:String = "walls";
        public static const FLOORS:String = "floors";

        static var category_names:Object;
        static var category_ids:Object;
        static var subcategory_names:Object;
        static var subcategory_ids:Object;
        static var subcategory_categories:Object;

        public static function parseData(_arg1:Object):void{
            var _local2:Object;
            var _local4:int;
            category_names = {};
            category_ids = {};
            var _local3:int = _arg1.categories.length;
            while (_local4 < _local3)
            {
                _local2 = _arg1.categories[_local4];
                category_names[int(_local2.id)] = _local2.name;
                category_ids[_local2.name] = int(_local2.id);
                _local4++;
            };
            subcategory_names = {};
            subcategory_ids = {};
            subcategory_categories = {};
            _local3 = _arg1.subcategories.length;
            _local4 = 0;
            while (_local4 < _local3)
            {
                _local2 = _arg1.subcategories[_local4];
                subcategory_names[int(_local2.id)] = _local2.name.split(" ").join("_");
                subcategory_ids[_local2.name] = int(_local2.id);
                subcategory_categories[int(_local2.id)] = int(_local2.decor_category_id);
                _local4++;
            };
        }
        public static function category_id_for_name(_arg1:String):int{
            return (category_ids[_arg1]);
        }
        public static function category_name_for_id(_arg1:int):String{
            return (category_names[_arg1]);
        }
        public static function category_name_for_subcategory_id(_arg1:int):String{
            return (category_names[subcategory_categories[_arg1]]);
        }
        public static function subcategory_name_for_id(_arg1:int):String{
            return (subcategory_names[_arg1]);
        }

    }
}//package com.viroxoty.fashionista.data

