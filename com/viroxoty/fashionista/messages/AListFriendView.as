// Decompiled by AS3 Sorcerer 1.78
// http://www.as3sorcerer.com/

//com.viroxoty.fashionista.messages.AListFriendView

package com.viroxoty.fashionista.messages{
    import flash.text.TextFormat;
    import flash.display.MovieClip;
    import com.viroxoty.fashionista.data.Friend;
    import com.viroxoty.fashionista.asset.AssetDataObject;
    import flash.display.DisplayObject;
    import flash.events.MouseEvent;
    import com.viroxoty.fashionista.*;
    import flash.events.*;
    import flash.text.*;
    import flash.display.*;
    import com.viroxoty.fashionista.asset.*;
    import com.viroxoty.fashionista.main.*;
    import com.viroxoty.fashionista.util.*;

    public class AListFriendView {

        static var tf:TextFormat;

        var view:MovieClip;
        var data:Friend;

        public function AListFriendView(_arg1:MovieClip, _arg2:Friend){
            if (tf == null)
            {
                tf = new TextFormat();
                tf.font = "Arial";
                tf.bold = true;
            };
            this.view = _arg1;
            this.data = _arg2;
            this.view.name_txt.defaultTextFormat = tf;
            this.view.name_txt.text = this.data.name;
            this.view.looks_btn.buttonMode = true;
            this.view.looks_btn.addEventListener(MouseEvent.CLICK, this.show_looks, false, 0, true);
            this.view.profile_btn.buttonMode = true;
            this.view.profile_btn.addEventListener(MouseEvent.CLICK, this.open_profile);
            this.view.delete_btn.buttonMode = true;
            this.view.delete_btn.addEventListener(MouseEvent.CLICK, this.delete_a_list);
            var _local3:AssetDataObject = new AssetDataObject();
            _local3.parseURL(this.data.pic_url);
            AssetManager.getInstance().getAssetFor(_local3, this);
        }
        public function assetLoaded(_arg1:DisplayObject, _arg2:String):void{
            Util.scaleAndCenterDisplayObject(_arg1, 50, 50);
            this.view.pic.addChild(_arg1);
        }
        function show_looks(_arg1:MouseEvent):void{
            Tracer.out(("show_looks for " + this.data.name));
            MainViewController.getInstance().show_preloader();
            DataManager.getInstance().get_a_lister_looks_xml(this.data.user_id, this.set_a_lister_looks_xml);
            Tracker.track("see_looks_attempt", "a_list");
        }
        public function set_a_lister_looks_xml(_arg1:XML):void{
            var _local2:int = _arg1.children().length();
            Tracer.out(("set_a_lister_looks_xml count: " + _local2));
            MainViewController.getInstance().hide_preloader();
            if (_local2 == 0)
            {
                Tracker.track("see_looks_no_looks", "a_list");
                Pop_Up.getInstance().alert((this.data.name + " hasn't entered any looks in this week's challenge yet!"));
                return;
            };
            MessageCenter.getInstance().close();
            Runway.getInstance().a_lister_xml = _arg1;
            if (Main.getInstance().current_section != "runway")
            {
                Runway.getInstance().load(Runway.A_LISTER_LOOKS);
            } else
            {
                Runway.getInstance().show_a_lister_looks();
            };
        }
        function open_profile(_arg1:MouseEvent):void{
            Tracer.out(("open profile: " + this.data.profile_url));
            var _local2:String = this.data.profile_url;
            Util.open_url(_local2);
        }
        function delete_a_list(_arg1:MouseEvent):void{
            Tracer.out(("delete_a_list: " + this.data.user_id));
            DataManager.getInstance().remove_from_a_list(this.data.user_id, this.delete_succeed, this.delete_succeed);
        }
        function delete_succeed():void{
            MessageCenter.getInstance().reload_a_list();
        }

    }
}//package com.viroxoty.fashionista.messages

