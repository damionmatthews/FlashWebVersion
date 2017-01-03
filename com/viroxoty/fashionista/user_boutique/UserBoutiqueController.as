// Decompiled by AS3 Sorcerer 1.78
// http://www.as3sorcerer.com/

//com.viroxoty.fashionista.user_boutique.UserBoutiqueController

package com.viroxoty.fashionista.user_boutique{
    import flash.display.MovieClip;
    import com.viroxoty.fashionista.data.UserBoutique;
    import com.viroxoty.fashionista.ui.ScrollingDirectoryController;
    import flash.display.DisplayObject;
    import flash.display.BitmapData;
    import flash.events.*;
    import com.viroxoty.fashionista.ui.*;
    import flash.display.*;
    import com.viroxoty.fashionista.util.*;

    public class UserBoutiqueController {

        public var view:MovieClip;
        public var decor_manager:DecorManager;
        public var boutique:UserBoutique;
        public var current_floor:int;
        public var directory_controller:ScrollingDirectoryController;

        public function init():void{
            Tracer.out("UserBoutiqueController > init");
            this.view.floor_ui.floor_txt.text = "";
            this.view.visits_ui.all_visits_txt.text = "";
            this.hide_floor_tip();
            Util.hideTips(this.view);
            this.view.visits_ui.addEventListener(MouseEvent.ROLL_OVER, this.show_visits_tip, false, 0, true);
            this.view.visits_ui.addEventListener(MouseEvent.ROLL_OUT, this.hide_visits_tip, false, 0, true);
            this.directory_controller = new ScrollingDirectoryController();
            this.directory_controller.mode = ScrollingDirectoryController.MODE_A_LIST;
            this.view.directory.visible = false;
        }
        public function hide_floor_tip(_arg1=null){
            this.view.floor_tip.visible = false;
            if (((_arg1) && (_arg1.currentTarget)))
            {
                _arg1.currentTarget.gotoAndStop(1);
            };
        }
        public function show_visits_tip(_arg1=null):void{
            this.view.visits_tip.visible = true;
        }
        public function hide_visits_tip(_arg1=null):void{
            this.view.visits_tip.visible = false;
        }
        public function generate_bitmap_data(scaleX:Number, scaleY:Number, width:int, height:int){
            var was_vis:Array;
            var to:UserBoutiqueObjectViewController;
            var model_ui_open:Boolean;
            this.view.scaleX = scaleX;
            this.view.scaleY = scaleY;
            var hide_ui:Array = ["a_list_btn", "directory", "floor_ui", "visits_ui", "tip_heart", "deal_spot_container", "star_btn", "tip_heart", "heart_btn", "decorate_btn", "photo_btn", "befriend_btn"];
            was_vis = new Array(hide_ui.length);
            hide_ui.forEach(function (_arg1:String, _arg2:int, _arg3:Array){
                var _local4:DisplayObject = view[_arg1];
                was_vis[_arg2] = _local4.visible;
                _local4.visible = false;
            });
            if (this.decor_manager)
            {
                to = this.decor_manager.hide_transform_box();
                model_ui_open = this.decor_manager.hide_model_ui();
            };
            var bd:BitmapData = new BitmapData(width, height, false, 0);
            bd.draw(this.view.parent);
            this.view.scaleX = 1;
            this.view.scaleY = 1;
            hide_ui.forEach(function (_arg1:String, _arg2:int, _arg3:Array){
                var _local4:DisplayObject = view[_arg1];
                _local4.visible = was_vis[_arg2];
            });
            if (this.decor_manager)
            {
                if (model_ui_open)
                {
                    this.decor_manager.reshow_model_ui();
                };
                if (to)
                {
                    this.decor_manager.reshow_transform_box(to);
                };
            };
            return (bd);
        }

    }
}//package com.viroxoty.fashionista.user_boutique

