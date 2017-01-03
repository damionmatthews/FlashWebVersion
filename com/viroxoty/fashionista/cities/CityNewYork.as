// Decompiled by AS3 Sorcerer 1.78
// http://www.as3sorcerer.com/

//com.viroxoty.fashionista.cities.CityNewYork

package com.viroxoty.fashionista.cities{
    import flash.display.Loader;
    import com.viroxoty.fashionista.UserData;
    import flash.display.MovieClip;
    import flash.events.MouseEvent;
    import com.viroxoty.fashionista.*;
    import flash.events.*;
    import com.viroxoty.fashionista.boutique.*;
    import com.viroxoty.fashionista.events.*;
    import com.viroxoty.fashionista.ui.*;
    import flash.display.*;
    import com.viroxoty.fashionista.asset.*;
    import com.viroxoty.fashionista.main.*;
    import com.viroxoty.fashionista.util.*;
    import com.viroxoty.fashionista.thirdParty.*;

    public class CityNewYork extends AbstractCity {

        private static var _instance:CityNewYork;
        private static var notified:Boolean;

        private var dealspot:Loader;

        public function CityNewYork(){
            id = 1;
            CityManager.getInstance().current_city = id;
            super();
            _instance = this;
            Tracer.out("New CityNewYork");
        }
        public static function getInstance():CityNewYork{
            if (_instance == null)
            {
                _instance = new (CityNewYork)();
            };
            return (_instance);
        }

        override public function load(){
            Main.getInstance().set_section(Constants.SECTION_CITY);
        }
        override public function init(){
            var _local1:Boolean;
            Tracer.out("CityNewYork > init");
            mc = MainViewController.getInstance().screen;
            super.init();
            setup_boutiques();
            this.add_button_events();
            var _local2:UserData = UserData.getInstance();
            if (((_local2.first_time_visit()) && ((_local2.visited_city < 2))))
            {
                _local2.visited_city++;
                if (_local2.visited_city == 2)
                {
                    _local2.check_show_3_day_reward();
                    _local1 = true;
                };
            };
            if (((_local2.shopping_welcome) && ((((_local2.visited_city == 2)) || ((_local2.first_time_visit() == false))))))
            {
                if (_local1)
                {
                    EventHandler.getInstance().queue_shopping_tip();
                } else
                {
                    PopupIntro.getInstance().display_popup(PopupIntro.SHOPPING_TIP);
                };
            };
        }
        override public function destroy(){
            super.destroy();
            var _local2:* = city_mc.dressing_room;
            var _local2 = _local2;
            with (_local2)
            {
                removeEventListener(MouseEvent.CLICK, open_dressing_room);
                removeEventListener(MouseEvent.MOUSE_OVER, store_over);
                removeEventListener(MouseEvent.MOUSE_OUT, store_out);
            };
            var runway_btn:MovieClip = mc.runway_mc;
            runway_btn.removeEventListener(MouseEvent.CLICK, open_runway);
            _local2 = city_mc.vip_button;
            with (_local2)
            {
                removeEventListener(MouseEvent.CLICK, click_paris);
                removeEventListener(MouseEvent.MOUSE_OVER, store_over);
                removeEventListener(MouseEvent.MOUSE_OUT, store_out);
            };
        }
        public function hide_free_item_btn():void{
            mc.free_item_btn.visible = false;
        }
        public function show_free_item_btn():void{
            if (mc == null)
            {
                return;
            };
            mc.free_item_btn.visible = false;
            if (this.dealspot)
            {
                this.dealspot.y = 160;
            };
        }
        private function add_button_events():void{
            var _local2:* = city_mc.dressing_room;
            var _local2 = _local2;
            with (_local2)
            {
                buttonMode = true;
                addEventListener(MouseEvent.CLICK, open_dressing_room, false, 0, true);
                addEventListener(MouseEvent.MOUSE_OVER, store_over, false, 0, true);
                addEventListener(MouseEvent.MOUSE_OUT, store_out, false, 0, true);
            };
            city_mc.dressing_room.startScaleX = city_mc.dressing_room.scaleX;
            city_mc.dressing_room.startScaleY = city_mc.dressing_room.scaleY;
            var runway_btn:MovieClip = mc.runway_mc;
            _local2 = runway_btn;
            with (_local2)
            {
                buttonMode = true;
                addEventListener(MouseEvent.CLICK, open_runway, false, 0, true);
            };
            Util.create_tooltip("CLICK HERE TO VOTE OR COMPETE!", runway_btn);
            this.setup_btn(city_mc.vip_button, this.click_paris);
            Util.create_tooltip("CLICK HERE TO FLY TO FANTASY PARIS!", mc, "left", "bottom", city_mc.vip_button);
            this.setup_btn(mc.plane_btn, this.click_paris);
            mc.plane_btn.y = (mc.plane_btn.y - 10);
            mc.free_cash_btn.visible = false;
            mc.free_item_btn.y = (mc.free_cash_btn.y - 10);
            if (Constants.SHOW_FREE_ITEM)
            {
                this.setup_btn(mc.free_item_btn, this.open_item_offer);
                if (UserData.getInstance().daily_sponsored_item == false)
                {
                    this.hide_free_item_btn();
                };
            } else
            {
                this.hide_free_item_btn();
            };
            var dsy:int = ((mc.free_item_btn.visible) ? 150 : 90);
            DealSpotController.add_deal_spot(mc, 5, dsy);
        }
        private function setup_btn(btn:MovieClip, method:Function):void{
            var _local4:* = btn;
            var _local4 = _local4;
            with (_local4)
            {
                buttonMode = true;
                mouseChildren = false;
                addEventListener(MouseEvent.CLICK, method, false, 0, true);
                addEventListener(MouseEvent.MOUSE_OVER, store_over, false, 0, true);
                addEventListener(MouseEvent.MOUSE_OUT, store_out, false, 0, true);
            };
            btn.startScaleX = btn.scaleX;
            btn.startScaleY = btn.scaleY;
        }
        private function click_paris(_arg1:MouseEvent):void{
            CityManager.getInstance().check_paris();
        }
        private function open_item_offer(_arg1:MouseEvent):void{
            MainViewController.getInstance().open_free_item_popup();
        }

    }
}//package com.viroxoty.fashionista.cities

