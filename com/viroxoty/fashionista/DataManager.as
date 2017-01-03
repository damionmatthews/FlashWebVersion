// Decompiled by AS3 Sorcerer 1.78
// http://www.as3sorcerer.com/

//com.viroxoty.fashionista.DataManager

package com.viroxoty.fashionista{
    import com.viroxoty.fashionista.data.Item;
    import com.viroxoty.fashionista.data.Styles;
    import com.viroxoty.fashionista.cities.CityManager;
    import com.adobe.serialization.json.Json;
    import com.viroxoty.fashionista.data.Team;
    import com.viroxoty.fashionista.util.Tracer;
    import flash.events.HTTPStatusEvent;
    import com.viroxoty.fashionista.main.MainViewController;
    import flash.events.IOErrorEvent;
    import flash.net.URLVariables;
    import flash.events.Event;
    import flash.net.URLRequest;
    import flash.net.URLRequestMethod;
    import flash.net.URLLoader;
    import com.viroxoty.fashionista.util.Constants;
    import com.viroxoty.fashionista.boutique.BoutiqueDataObject;
    import com.viroxoty.fashionista.ui.SnapshotController;
    import com.viroxoty.fashionista.data.DecorCategories;
    import com.viroxoty.fashionista.util.Errors;
    import com.viroxoty.fashionista.data.Decor;
    import com.viroxoty.fashionista.data.PurchasableObject;
    import com.viroxoty.fashionista.events.EventHandler;
    import com.viroxoty.fashionista.user_boutique.BoutiqueVisit;
    import __AS3__.vec.Vector;
    import flash.net.URLRequestHeader;
    import com.viroxoty.fashionista.util.PNGGenerator;
    import com.viroxoty.fashionista.data.UserBoutique;
    import com.viroxoty.fashionista.data.UserDecor;
    import com.viroxoty.fashionista.data.UserBoutiqueModel;
    import flash.utils.ByteArray;
    import com.viroxoty.fashionista.data.Album;
    import com.viroxoty.fashionista.data.*;
    import flash.events.*;
    import flash.net.*;
    import com.viroxoty.fashionista.boutique.*;
    import com.viroxoty.fashionista.ui.*;
    import com.viroxoty.fashionista.events.*;
    import com.viroxoty.fashionista.cities.*;
    import com.viroxoty.fashionista.util.*;
    import com.adobe.serialization.json.JSON;
    import flash.display.BitmapData;

    public class DataManager {

        private static var _instance:DataManager;
        public static var user_id:String;
        public static var debug_user_id:String;

        var main:Main;
        var user:UserData;
        var client_key:String;
        var fb_session:String;
        var send_data:Object;
        var last_vote:Object;
        var buy_votes_over_limit:Boolean = false;
        var last_look:Object;
        var buy_looks_over_limit:Boolean = false;
        var tries_png_save:int;
        var last_invite:Object;
        var buy_invites_over_limit:Boolean = false;
        public var free_item:Item;
        public var free_item_code:int = -1;
        public var daily_deal_item:Item;
        public var teams:Array;
        var get_enter_look_reward:Boolean;
        var avatar_item_ids:String;
        var avatar_styles:Styles;
        var cur_avatar_controller:AvatarController;

        public function DataManager(_arg1:Main){
            this.main = _arg1;
            _instance = this;
            this.user = UserData.getInstance();
        }
        public static function getInstance():DataManager{
            return (_instance);
        }

        public function get_startup_data(){
            CityManager.getInstance().addEventListener("data_received", this.main.view.city_data_received);
            this.get_friends();
            this.get_a_list(this.user.process_a_list_json, null);
            this.load_decor_category_data();
        }
        public function process_free_item(_arg1:String):void{
            if (_arg1 == "false")
            {
                return;
            };
            var _local2:Object = Json.decode(_arg1);
            this.free_item = new Item();
            this.free_item.parseFreeItem(_local2);
            UserData.getInstance().daily_sponsored_item = true;
        }
        public function get_free_item_name():String{
            if (this.free_item)
            {
                return (this.free_item.name);
            };
            return ("");
        }
        public function process_daily_deal_item(_arg1:String):void{
            if (_arg1 == "false")
            {
                return;
            };
            var _local2:Object = Json.decode(_arg1);
            this.daily_deal_item = new Item();
            this.daily_deal_item.parseFreeItem(_local2);
        }
        public function add_daily_deal_item():void{
            this.user.add_to_closet(this.daily_deal_item);
            this.check_user_balances();
            this.daily_deal_item = null;
        }
        public function process_teams(_arg1:String):void{
            var _local5:Team;
            var _local2:Object = Json.decode(_arg1);
            Team.icon_path = _local2.icons_path;
            Team.large_path = _local2.large_path;
            this.teams = [];
            var _local3:int = _local2.list.length;
            Tracer.out(("process_teams: " + _local3));
            var _local4:int;
            while (_local4 < _local3)
            {
                _local5 = new Team();
                _local5.parseServerTeam(_local2.list[_local4]);
                this.teams.push(_local5);
                _local4++;
            };
            this.teams.sortOn("id", Array.NUMERIC);
        }
        public function get_team_by_id(_arg1:int):Team{
            var _local2:int = this.teams.length;
            Tracer.out(("process_teams: " + _local2));
            var _local3:int;
            while (_local3 < _local2)
            {
                if (this.teams[_local3].id == _arg1)
                {
                    return (this.teams[_local3]);
                };
                _local3++;
            };
            return (null);
        }
        public function get_top_team():Team{
            var _local1:int = this.teams[0].votes;
            var _local2:int;
            var _local3:int = this.teams.length;
            var _local4:int = 1;
            while (_local4 < _local3)
            {
                if (this.teams[_local4].votes > _local1)
                {
                    _local1 = this.teams[_local4].votes;
                    _local2 = _local4;
                };
                _local4++;
            };
            return (this.teams[_local2]);
        }
        public function httpStatusHandler(_arg1:HTTPStatusEvent):void{
            Tracer.out(("httpStatusHandler: " + _arg1));
            Tracer.out(("status: " + _arg1.status));
        }
        public function ioErrorHandler(_arg1:IOErrorEvent):void{
            Tracer.out(("ioErrorHandler: " + _arg1));
            MainViewController.getInstance().hide_preloader();
        }
        public function completeHandler(_arg1:Event):void{
            var _local2:Object;
            var _local3:String;
            try
            {
                _local2 = new URLVariables(_arg1.target.data);
                for (_local3 in _local2)
                {
                };
            } catch(e:Error)
            {
            };
        }
        public function make_request(_arg1:String):URLRequest{
            var _local2:URLRequest = new URLRequest(_arg1);
            (_local2.method = URLRequestMethod.POST);
            var _local3:URLVariables = new URLVariables();
            (_local3.user_id = ((debug_user_id) ? debug_user_id : user_id));
            (_local3.client_key = this.client_key);
            (_local3.session = this.fb_session);
            (_local2.data = _local3);
            return (_local2);
        }
        public function make_loader():URLLoader{
            var _local1:URLLoader = new URLLoader();
            _local1.addEventListener(Event.COMPLETE, this.completeHandler);
            _local1.addEventListener(IOErrorEvent.IO_ERROR, this.ioErrorHandler);
            _local1.addEventListener(HTTPStatusEvent.HTTP_STATUS, this.httpStatusHandler);
            return (_local1);
        }
        public function get_user_data():void{
            var data_loaded:Function;
            data_loaded = function (_arg1:Event):void{
                Tracer.out(("get_user_data returned: " + _arg1.target.data));
				//Main.getInstance().txt11.text=_arg1.target.data;
				//Pop_Up.getInstance().alert(_arg1.target.data);
				
                var _local2:Object = Json.decode(_arg1.target.data);
                if (_local2.status == 0)
                {
                    user.processStartupData(_local2.data.userData);
                    Main.getInstance().view.check_first_screen_swfs();
                } else
                {
                    Tracer.out(("DataManager > get_user_data : KO : " + _local2.message));
                };
            };
            Tracer.out("DataManager > get_user_data");
			//Pop_Up.getInstance().alert(user_id);
            var path:String = ((Constants.SERVER_JSON + "load_user_data.php?time=") + new Date().time);
            var req:URLRequest = this.make_request(path);
            if (debug_user_id)
            {
                (req.data.debug_user_id = debug_user_id);
                Tracer.out(("DataManager > get_user_data: using debug_user_id " + debug_user_id));
            };
            var loader:URLLoader = this.make_loader();
            loader.addEventListener(Event.COMPLETE, data_loaded);
            loader.load(req);
        }
        public function check_user_balances():void{
            var data_loaded:Function;
            data_loaded = function (_arg1:Event):void{
                Tracer.out(("get_user_balances returned: " + _arg1.target.data));
                var _local2:Object = Json.decode(_arg1.target.data);
                if (_local2.status == 0)
                {
                    user.checked_user_balances(_local2.data.points, _local2.data.level, _local2.data.coins, _local2.data.mini_level_ups);
                } else
                {
                    Tracer.out(("DataManager > get_user_balances : KO : " + _local2.message));
                };
            };
            Tracer.out("DataManager > check_user_balances");
            var path:String = ((Constants.SERVER_JSON + "get_user_balances.php?time=") + new Date().time);
            var req:URLRequest = this.make_request(path);
            var loader:URLLoader = this.make_loader();
            loader.addEventListener(Event.COMPLETE, data_loaded);
            loader.load(req);
        }
        public function get_friends():void{
            var data_loaded:Function;
            data_loaded = function (_arg1:Event):void{
				//Main.getInstance().txt11.text="DM->getfriends   "+_arg1.target.data;
                var _local2:Object = Json.decode(_arg1.target.data);
                if (_local2.status == 0)
                {
                    Tracer.out("DataManager > get_friends : ok");
                    user.process_friends(_local2.data.friends.data);
                } else
                {
                    Tracer.out(("DataManager > get_friends : KO : " + _local2.message));
                };
            };
            Tracer.out("DataManager > get_friends");
            //var path:String = (Constants.SERVER_JSON + "get_friends.php");
			var path:String = ("https://viroxoty.com/testing/json/get_friends.php");
            var req:URLRequest = this.make_request(path);
            var loader:URLLoader = this.make_loader();
            loader.addEventListener(Event.COMPLETE, data_loaded);
            loader.load(req);
        }
        public function get_a_list(success:Function, fail:Function):void{
            var data_loaded:Function;
            data_loaded = function (_arg1:Event):void{
                Tracer.out("DataManager > get_a_list returned ");
				//Pop_Up.getInstance().alert(_arg1.target.data);
                var _local2:Object = Json.decode(_arg1.target.data);
                if (_local2.status == 0)
                {
                    success(_local2.data);
                    Main.getInstance().view.check_first_screen_swfs();
                } else
                {
                    Tracer.out(("DataManager > get_a_list : KO : " + _local2.message));
                    fail();
                };
            };
			var path:String = ((Constants.SERVER_JSON + "get_a_list.php?time=") + new Date().time);
            Tracer.out(("DataManager > get a_list from : " + path));
            var req:URLRequest = this.make_request(path);
            var loader:URLLoader = this.make_loader();
            loader.addEventListener(Event.COMPLETE, data_loaded);
            loader.load(req);
        }
        public function get_runway_contestant_bar_data(success:Function, fail:Function):void{
            var data_loaded:Function;
            data_loaded = function (_arg1:Event):void{
                Tracer.out(("DataManager > get_runway_contestant_bar_data : " + _arg1.target.data));
                var _local2:Object = Json.decode(_arg1.target.data);
                if (_local2.status == 0)
                {
                    success(_local2.data);
                } else
                {
                    Tracer.out(("DataManager > get_runway_contestant_bar_data : KO : " + _local2.message));
                    fail();
                };
            };
            //var path:String = ((Constants.SERVER_JSON + "get_runway_contestant_bar_data.php?time=") + new Date().time);
			var path:String = (("http://viroxotystudios.com/testing/json/get_runway_contestant_bar_data.php?user_id="+user_id.toString()+"&time=") + new Date().time);
            Tracer.out(("DataManager > get_runway_contestant_bar_data from : " + path));
            var req:URLRequest = this.make_request(path);
            var loader:URLLoader = this.make_loader();
            loader.addEventListener(Event.COMPLETE, data_loaded);
            loader.load(req);
        }
        public function check_free_item():void{
            var reward_free_item:Function;
            reward_free_item = function ():void{
                user.reward_free_item();
                Pop_Up.getInstance().alert((("You've received today's free item: " + free_item.name) + "!"));
            };
            var no_free_item:Function = function ():void{
                (user.daily_sponsored_item = true);
            };
            this.check_user_closet(this.free_item.id, reward_free_item);
        }
        public function check_user_closet(item_id:int, success_callback:Function, fail_callback:Function=null):void{
            var data_loaded:Function;
            data_loaded = function (_arg1:Event):void{
                Tracer.out(("check_user_closet json loaded: " + _arg1.target.data));
                var _local2:Object = Json.decode(_arg1.target.data);
                if (_local2.data[item_id] == true)
                {
                    success_callback();
                } else
                {
                    if (fail_callback != null)
                    {
                        fail_callback();
                    };
                };
            };
            var url:String = (Constants.SERVER_JSON + "check_user_closet.php");
            Tracer.out(("DataManager > check_user_closet : url is " + url));
            var req:URLRequest = this.make_request(url);
            (req.data.item_ids = String(item_id));
            var loader:URLLoader = this.make_loader();
            loader.addEventListener(Event.COMPLETE, data_loaded);
            loader.load(req);
        }
        public function get_daily_gifts(success:Function):void{
            var data_loaded:Function;
            data_loaded = function (_arg1:Event):void{
                Tracer.out(("DataManager > get_daily_gifts : " + _arg1.target.data));
                var _local2:Object = Json.decode(_arg1.target.data);
                if (_local2.gifts)
                {
                    success(_local2.gifts);
                } else
                {
                    Tracer.out(("DataManager > get_daily_gifts : KO : " + _local2));
                };
            };
            var path:String = (Constants.SERVER_JSON + "get_daily_gifts.php");
            Tracer.out("DataManager > get_daily_gifts");
            var req:URLRequest = this.make_request(path);
            var loader:URLLoader = this.make_loader();
            loader.addEventListener(Event.COMPLETE, data_loaded);
            loader.load(req);
        }
        public function get_messages():void{
            var data_loaded:Function;
            data_loaded = function (_arg1:Event):void{
                Tracer.out(("DataManager > load_message_center : " + _arg1.target.data));
                var _local2:Object = Json.decode(_arg1.target.data);
                if (_local2.status == 0)
                {
                    MessageCenter.getInstance().messages_loaded(_local2.data.messages);
                } else
                {
                    Tracer.out(("DataManager > load_message_center : KO : " + _local2.message));
                };
            };
            var path:String = ((Constants.SERVER_JSON + "load_message_center.php?time=") + new Date().time);
            Tracer.out(("DataManager > get messages from : " + path));
            var req:URLRequest = this.make_request(path);
            var loader:URLLoader = this.make_loader();
            loader.addEventListener(Event.COMPLETE, data_loaded);
            loader.load(req);
        }
      	public function get_boutique_data(bdo:BoutiqueDataObject, callback:Function):void {
			var url:String = Constants.SERVER_JSON + "boutique_data.php?boutique_id=" + bdo.id;
			Tracer.out("DataManager > get_boutique_data : url is "+url);
			var req:URLRequest = make_request(url);
			
			var loader:URLLoader = make_loader();
			loader.addEventListener(Event.COMPLETE, data_loaded);
			loader.load(req);

			function data_loaded(event:Event):void {
				Tracer.out("boutique_data json loaded: "+event.target.data);
				//Pop_Up.getInstance().alert(event.target.data);
				callback(bdo, event.target.data);
			}
		}
        public function get_boutique_decor(id:int, callback:Function):void{
            var data_loaded:Function;
            data_loaded = function (_arg1:Event):void{
                Tracer.out(("boutique_data json loaded: " + _arg1.target.data));
                var _local2:Array = Json.decode(_arg1.target.data);
                callback(_local2);
            };
            var url:String = ((Constants.SERVER_JSON + "boutique_decor.php?boutique_id=") + id);
            Tracer.out(("DataManager > boutique_decor : url is " + url));
            var req:URLRequest = this.make_request(url);
            var loader:URLLoader = this.make_loader();
            loader.addEventListener(Event.COMPLETE, data_loaded);
            loader.load(req);
        }
        public function check_best_dressed():void{
            var data_loaded:Function;
            data_loaded = function (_arg1:Event):void{
                Tracer.out((" check_best_dressed > received " + _arg1.target.data));
                if (_arg1.target.data == '"true"')
                {
                    if (SnapshotController.getInstance().is_open)
                    {
                        (SnapshotController.getInstance().pending_best_dressed = true);
                    } else
                    {
                        user.show_best_dressed();
                    };
                };
            };
            if (Main.getInstance().current_section != Constants.SECTION_RUNWAY)
            {
                return;
            };
            Tracer.out("DataManager > check_best_dressed");
            (this.user.didGetBestDressed == true);
            var path:String = (Constants.SERVER_JSON + "check_best_dressed_list.php");
            var req:URLRequest = this.make_request(path);
            var loader:URLLoader = this.make_loader();
            loader.addEventListener(Event.COMPLETE, data_loaded);
            loader.load(req);
        }
        public function load_decor_category_data():void{
            var data_loaded:Function;
            data_loaded = function (_arg1:Event):void{
                Tracer.out(("DataManager > load_decor_category_data: received " + _arg1.target.data));
                var _local2:Object = Json.decode(_arg1.target.data);
                if (_local2.status == 0)
                {
                    Tracer.out("DataManager > load_decor_category_data : ok");
                    DecorCategories.parseData(_local2.data);
                } else
                {
                    Tracer.out(("DataManager > load_decor_category_data : KO : " + _local2.message));
                };
            };
            Tracer.out("DataManager > load_decor_category_data");
            var request:URLRequest = this.make_request(("http://viroxoty.com/testing/json/load_decor_category_data.php"));
            var loader:URLLoader = this.make_loader();
            loader.addEventListener(Event.COMPLETE, data_loaded);
            loader.load(request);
        }
        public function load_decor_category(category_id:int, success:Function=null, fail:Function=null):void{
            var data_loaded:Function;
            data_loaded = function (_arg1:Event):void{
                Tracer.out(("DataManager > load_decor_category: received " + _arg1.target.data));
                var _local2:Object = Json.decode(_arg1.target.data);
                if (_local2.status == 0)
                {
                    Tracer.out("DataManager > load_decor_category : ok");
                    if (success != null)
                    {
                        success(_local2.data);
                    };
                } else
                {
                    Tracer.out(("DataManager > load_decor_category : KO : " + _local2.message));
                    if (fail != null)
                    {
                        fail();
                    };
                };
            };
            Tracer.out(("DataManager > load_decor_category: " + category_id));
            var request:URLRequest = this.make_request((Constants.SERVER_JSON + "load_decor_category.php"));
            (request.data.category_id = category_id);
            var loader:URLLoader = this.make_loader();
            loader.addEventListener(Event.COMPLETE, data_loaded);
            loader.load(request);
        }
        public function load_item_category(category_id:int, success:Function=null, fail:Function=null):void{
            var data_loaded:Function;
            data_loaded = function (_arg1:Event):void{
                Tracer.out(("DataManager > load_item_category: received " + _arg1.target.data));
                var _local2:Object = Json.decode(_arg1.target.data);
                if (_local2.status == 0)
                {
                    Tracer.out("DataManager > load_item_category : ok");
                    if (success != null)
                    {
                        success(_local2.data);
                    };
                } else
                {
                    Tracer.out(("DataManager > load_item_category : KO : " + _local2.message));
                    if (fail != null)
                    {
                        fail();
                    };
                };
            };
            Tracer.out(("DataManager > load_item_category: " + category_id));
            var request:URLRequest = this.make_request((Constants.SERVER_JSON + "load_item_category.php"));
            (request.data.category_id = category_id);
            var loader:URLLoader = this.make_loader();
            loader.addEventListener(Event.COMPLETE, data_loaded);
            loader.load(request);
        }
        public function get_dummy_faceoff_opponent(success:Function, fail:Function):void{
            var data_loaded:Function;
            data_loaded = function (_arg1:Event):void{
                Tracer.out(("DataManager > get_dummy_faceoff_opponent: received " + _arg1.target.data));
                var _local2:Object = Json.decode(_arg1.target.data);
                if (_local2.status == 0)
                {
                    Tracer.out("DataManager > get_dummy_faceoff_opponent : ok");
                    success(_local2.data);
                } else
                {
                    Tracer.out(("DataManager > get_dummy_faceoff_opponent : KO : " + _local2.message));
                    fail();
                };
            };
            Tracer.out("DataManager > get_dummy_faceoff_opponent");
            var request:URLRequest = this.make_request((Constants.SERVER_JSON + "get_dummy_faceoff_opponent.php"));
            var loader:URLLoader = this.make_loader();
            loader.addEventListener(Event.COMPLETE, data_loaded);
            loader.load(request);
        }
        public function get_contest_xml(obj:Object):void{
            var xml_loaded:Function;
            xml_loaded = function (_arg1:Event):void{
                var _local2:* = new XML(_arg1.target.data);
                obj.set_contest_xml(_local2);
            };
            Tracer.out("DataManager > calling ClockXML.php");
            var path:String = ((Constants.SERVER_XML + "ClockXML.php?str=") + Math.random());
            var xml_req:URLRequest = this.make_request(path);
            var loader:URLLoader = this.make_loader();
            loader.addEventListener(Event.COMPLETE, xml_loaded);
            loader.load(xml_req);
        }
        public function get_cities_data(callback:Function):void{
            var xml_loaded:Function;
            xml_loaded = function (_arg1:Event):void{
                var _local2:* = new XML(_arg1.target.data);
                callback(_local2);
            };
            Tracer.out("DataManager > calling city_data.php");
            var path:String = ((Constants.SERVER_XML + "city_data.php?str=") + Math.random());
            var xml_req:URLRequest = this.make_request(path);
            var loader:URLLoader = this.make_loader();
            loader.addEventListener(Event.COMPLETE, xml_loaded);
            loader.load(xml_req);
        }
        public function get_items_xml(boutique_id:String, obj:Object, callback:Function):void{
            var xml_loaded:Function;
            xml_loaded = function (_arg1:Event):void{
                var _local2:*;
                Tracer.out(("boutique_items xml loaded; main.current_section is " + main.current_section));
                if (obj)
                {
                    _local2 = new XML(_arg1.target.data);
                    callback.call(obj, _local2);
                };
            };
            //var url:String = ((Constants.SERVER_XML + "boutique_items.php?boutique_id=") + boutique_id);
			var url:String = (("http://viroxoty.com/testing/xml/boutique_items.php?boutique_id=") + boutique_id);
            Tracer.out(("DataManager > get_items_xml : url is " + url));
            var xml_req:URLRequest = this.make_request(url);
            var loader:URLLoader = this.make_loader();
            loader.addEventListener(Event.COMPLETE, xml_loaded);
            loader.load(xml_req);
        }
        public function get_looks_xml(boutique_id:String, obj:Object, callback:Function):void{
            var xml_loaded:Function;
            xml_loaded = function (_arg1:Event):void{
                Tracer.out(("boutique_looks xml loaded; main.current_section is " + main.current_section));
                if (main.current_section != "boutique")
                {
                    return;
                };
                var _local2:* = new XML(_arg1.target.data);
                callback.call(obj, _local2);
            };
            var url:String = ((((Constants.SERVER_XML + "boutique_looks.php?user_id=") + user_id) + "&boutique_id=") + boutique_id);
            Tracer.out(("DataManager > get_looks_xml : url is " + url));
            var xml_req:URLRequest = this.make_request(url);
            var loader:URLLoader = this.make_loader();
            loader.addEventListener(Event.COMPLETE, xml_loaded);
            loader.load(xml_req);
        }
        public function get_boutique_look_xml(id:String, obj:Object):void{
            var xml_loaded:Function;
            xml_loaded = function (_arg1:Event):void{
                if (main.current_section != "boutique")
                {
                    return;
                };
                var _local2:* = new XML(_arg1.target.data);
                obj.set_boutique_look_items_xml(_local2);
            };
            var xml_req:URLRequest = this.make_request(((Constants.SERVER_XML + "boutique_look_items.php?id=") + id));
            var loader:URLLoader = this.make_loader();
            loader.addEventListener(Event.COMPLETE, xml_loaded);
            loader.load(xml_req);
        }
        public function get_runway_avatar_xml(obj:Object, direction:String=null, lastViewed:int=0):void{
            var xml_loaded:Function;
            xml_loaded = function (_arg1:Event):void{
                if (main.current_section != "runway")
                {
                    return;
                };
                if (_arg1.target.data == "-1")
                {
                    Pop_Up.getInstance().display_popup(Pop_Up.ALERT, "get_top_looks > general error");
                    main.view.hide_preloader();
                    return;
                };
                if (_arg1.target.data == "-2")
                {
                    Pop_Up.getInstance().display_popup(Pop_Up.ALERT, "get_top_looks > failed to query for top 50 looks");
                    main.view.hide_preloader();
                    return;
                };
                var _local2:* = new XML(_arg1.target.data);
                if (direction == "forward")
                {
                    obj.add_forward_chunk(_local2);
                } else
                {
                    if (direction == "backward")
                    {
                        obj.add_backward_chunk(_local2);
                    } else
                    {
                        obj.set_runway_avatar_xml(_local2);
                    };
                };
            };
            var path:String = ((Constants.SERVER_XML + "participating_avatars.php?time=") + new Date().time);
            var xml_req:URLRequest = this.make_request(path);
            (xml_req.data.contestid = TopMenu.get_contest_id());
            if (direction)
            {
                Tracer.out(((("    with direction = " + direction) + " and lastViewed = ") + lastViewed));
                (xml_req.data.direction = direction);
                (xml_req.data.lastViewed = lastViewed);
            };
            var loader:URLLoader = this.make_loader();
            loader.addEventListener(Event.COMPLETE, xml_loaded);
            loader.load(xml_req);
        }
        public function get_top_looks_xml(obj:Object):void{
            var xml_loaded:Function;
            xml_loaded = function (_arg1:Event):void{
                if (main.current_section != "runway")
                {
                    return;
                };
                if (_arg1.target.data == "-1")
                {
                    Pop_Up.getInstance().display_popup(Pop_Up.ALERT, "get_top_looks > general error");
                    main.view.hide_preloader();
                    return;
                };
                if (_arg1.target.data == "-2")
                {
                    Pop_Up.getInstance().display_popup(Pop_Up.ALERT, "get_top_looks > failed to query for top 50 looks");
                    main.view.hide_preloader();
                    return;
                };
                var _local2:* = new XML(_arg1.target.data);
                obj.set_top_looks_xml(_local2);
            };
            var path:String = ((Constants.SERVER_XML + "get_top_looks.php?time=") + new Date().time);
            Tracer.out(("DataManager > get_top_looks from " + path));
            var xml_req:URLRequest = this.make_request(path);
            (xml_req.data.count = Constants.TOP_LOOKS_COUNT);
            var loader:URLLoader = this.make_loader();
            loader.addEventListener(Event.COMPLETE, xml_loaded);
            loader.load(xml_req);
        }
        public function get_user_looks_xml(obj:Object, friends:Boolean=false):void{
            var xml_loaded:Function;
            xml_loaded = function (_arg1:Event):void{
                if (main.current_section != "runway")
                {
                    return;
                };
                if (_arg1.target.data == "-1")
                {
                    Pop_Up.getInstance().display_popup(Pop_Up.ALERT, "get_user_looks > general error");
                    main.view.hide_preloader();
                    return;
                };
                if (_arg1.target.data == "-2")
                {
                    Pop_Up.getInstance().display_popup(Pop_Up.ALERT, "get_user_looks > failed to look up friends");
                    main.view.hide_preloader();
                    return;
                };
                var _local2:* = new XML(_arg1.target.data);
                if (friends)
                {
                    obj.set_friends_looks_xml(_local2);
                } else
                {
                    obj.set_user_looks(_local2);
                };
            };
            var path:String = ((Constants.SERVER_XML + "get_user_looks.php?time=") + new Date().time);
            Tracer.out(("DataManager > get_user_looks from " + path));
            var xml_req:URLRequest = this.make_request(path);
            if (friends)
            {
                (xml_req.data.friends = "true");
            };
            var loader:URLLoader = this.make_loader();
            loader.addEventListener(Event.COMPLETE, xml_loaded);
            loader.load(xml_req);
        }
        public function get_a_lister_looks_xml(a_lister_uid:String, success:Function):void{
            var xml_loaded:Function;
            xml_loaded = function (_arg1:Event):void{
                if (_arg1.target.data == "-1")
                {
                    Pop_Up.getInstance().display_popup(Pop_Up.ALERT, "get_a_lister_looks_xml > general error");
                    main.view.hide_preloader();
                    return;
                };
                var _local2:* = new XML(_arg1.target.data);
                success(_local2);
            };
            var path:String = ((Constants.SERVER_XML + "get_user_looks.php?time=") + new Date().time);
            Tracer.out(("DataManager > get_user_looks from " + path));
            var xml_req:URLRequest = this.make_request(path);
            (xml_req.data.user_id = a_lister_uid);
            var loader:URLLoader = this.make_loader();
            loader.addEventListener(Event.COMPLETE, xml_loaded);
            loader.load(xml_req);
        }
        public function get_team_looks_xml(team_id:int, success:Function):void{
            var xml_loaded:Function;
            xml_loaded = function (_arg1:Event):void{
                if (main.current_section != Constants.SECTION_RUNWAY)
                {
                    return;
                };
                if (_arg1.target.data == "-1")
                {
                    Pop_Up.getInstance().display_popup(Pop_Up.ALERT, "get_team_looks > general error");
                    main.view.hide_preloader();
                    return;
                };
                if (_arg1.target.data == "-2")
                {
                    Pop_Up.getInstance().display_popup(Pop_Up.ALERT, "get_team_looks > failed to query for top 50 team looks");
                    main.view.hide_preloader();
                    return;
                };
                var _local2:* = new XML(_arg1.target.data);
                success(_local2);
            };
            var path:String = ((Constants.SERVER_XML + "get_team_looks.php?time=") + new Date().time);
            Tracer.out(("DataManager > get_team_looks from " + path));
            var xml_req:URLRequest = this.make_request(path);
            (xml_req.data.team_id = team_id);
            (xml_req.data.count = Constants.TOP_LOOKS_COUNT);
            var loader:URLLoader = this.make_loader();
            loader.addEventListener(Event.COMPLETE, xml_loaded);
            loader.load(xml_req);
        }
        public function get_closet_xml(cat_id:int, obj:Object):void{
            var xml_loaded:Function;
            xml_loaded = function (_arg1:Event):void{
                if (main.current_section != "dressing_room")
                {
                    return;
                };
                var _local2:* = new XML(_arg1.target.data);
                Tracer.out(("DataManager > got closet_xml : " + _local2.toString()));
                obj.set_closet_xml(_local2);
            };
            var path:String = ((((Constants.SERVER_XML + "user_closet.php?closet_catid=") + cat_id) + "&time=") + new Date().time);
            Tracer.out(("DataManager > get_closet_xml at : " + path));
            var xml_req:URLRequest = this.make_request(path);
            var loader:URLLoader = this.make_loader();
            loader.addEventListener(Event.COMPLETE, xml_loaded);
            loader.load(xml_req);
        }
        public function credit_user(reason:String, amount:int=-1):void{
            var data_loaded:Function;
            data_loaded = function (_arg1:Event):void{
                Tracer.out(("DataManager > credit_user: received " + _arg1.target.data));
                var _local2:Object = Json.decode(_arg1.target.data);
                if (_local2.status == 0)
                {
                    Tracer.out("DataManager > credit_user : ok");
                    (user.pending_fcash_reward = _local2.data.credit_amount);
                    check_user_balances();
                } else
                {
                    Tracer.out(("DataManager > credit_user : KO : " + _local2.message));
                };
            };
            Tracer.out("DataManager > credit_user");
            var request:URLRequest = this.make_request((Constants.SERVER_SERVICES + "credit_user.php"));
            (request.data.reason = reason);
            if (amount != -1)
            {
                (request.data.credit_amount = amount);
            };
            var loader:URLLoader = this.make_loader();
            loader.addEventListener(Event.COMPLETE, data_loaded);
            loader.load(request);
        }
        public function earn_experience(code:int, reward:int):void{
            var data_loaded:Function;
            data_loaded = function (_arg1:Event):void{
                Tracer.out(("DataManager > earn_experience : " + _arg1.target.data));
                var _local2:Object = Json.decode(_arg1.target.data);
                if (_local2.status == 0)
                {
                    (UserData.getInstance().pending_points_reward = reward);
                    check_user_balances();
                } else
                {
                    if (_local2.status == Errors.E_NO_FB_SESSION)
                    {
                        Pop_Up.getInstance().alert("Oops!  Facebook Session has expired.  Please reload the page.");
                    } else
                    {
                        if (_local2.status == Errors.E_INVALID_REWARD_CODE)
                        {
                            Pop_Up.getInstance().alert("Oops! Invalid reward code");
                        };
                    };
                };
            };
            Tracer.out(("calling earn_experience for code " + code));
            var request:URLRequest = this.make_request((Constants.SERVER_SERVICES + "earn_experience.php"));
            (request.data.code = code);
            var loader:URLLoader = this.make_loader();
            loader.addEventListener(Event.COMPLETE, data_loaded);
            loader.load(request);
        }
        public function buy_points(points:int):void{
            var bought_points:Function;
            bought_points = function (_arg1:Event):void{
                Tracer.out(("buy_points returned :" + _arg1.target.data));
                if (_arg1.target.data == -1)
                {
                    Tracer.out("Buy points: general error");
                    Pop_Up.getInstance().display_popup(Pop_Up.ALERT, "buy points - general error");
                    return;
                };
                if (_arg1.target.data == Errors.E_USER_INSUFFICIENT_FUNDS)
                {
                    Pop_Up.getInstance().display_popup(Pop_Up.NEED_MORE_CASH);
                    return;
                };
                (user.pending_points_purchase = true);
                check_user_balances();
            };
            Tracer.out(((((("calling buy_points for " + points) + ", user_id ") + user_id) + ", client_key ") + this.client_key));
            var request:URLRequest = this.make_request((Constants.SERVER_SERVICES + "buy_points.php"));
            (request.data.points = points);
            var loader:URLLoader = this.make_loader();
            loader.addEventListener(Event.COMPLETE, bought_points);
            loader.load(request);
        }
        public function read_messages(message_ids:String):void{
            var data_loaded:Function;
            data_loaded = function (_arg1:Event):void{
                Tracer.out(("DataManager > read_messages : " + _arg1.target.data));
                var _local2:Object = Json.decode(_arg1.target.data);
                if (_local2.status == 0)
                {
                    Tracer.out("DataManager > marked messages as read : ok");
                } else
                {
                    Tracer.out(("DataManager > marked messages as read : KO : " + _local2.message));
                };
            };
            var path:String = (Constants.SERVER_SERVICES + "read_messages.php");
            Tracer.out(("DataManager > mark messages as read : " + message_ids));
            var req:URLRequest = this.make_request(path);
            (req.data.message_ids = message_ids);
            var loader:URLLoader = this.make_loader();
            loader.addEventListener(Event.COMPLETE, data_loaded);
            loader.load(req);
        }
        public function delete_messages(message_ids:String):void{
            var data_loaded:Function;
            data_loaded = function (_arg1:Event):void{
                Tracer.out(("DataManager > delete_messages : " + _arg1.target.data));
                var _local2:Object = Json.decode(_arg1.target.data);
                if (_local2.status == 0)
                {
                    Tracer.out("DataManager > deleted messages : ok");
                } else
                {
                    Tracer.out(("DataManager > deleted messages : KO : " + _local2.message));
                };
            };
            var path:String = (Constants.SERVER_SERVICES + "delete_messages.php");
            Tracer.out(("DataManager > delete_messages : " + message_ids));
            var req:URLRequest = this.make_request(path);
            (req.data.message_ids = message_ids);
            var loader:URLLoader = this.make_loader();
            loader.addEventListener(Event.COMPLETE, data_loaded);
            loader.load(req);
        }
        public function send_thank_you_gift(recipient_id:String, id:int, callback:Function, fail_callback:Function):void{
            var data_loaded:Function;
            data_loaded = function (_arg1:Event):void{
                var _local3:Decor;
                Tracer.out(("DataManager > send_thank_you_gift : " + _arg1.target.data));
                var _local2:Object = Json.decode(_arg1.target.data);
                if (_local2.status == 0)
                {
                    Tracer.out("DataManager > send_thank_you_gift : ok");
                    _local3 = Decor.parseServerData(_local2.data.decor);
                    if (id != _local3.id)
                    {
                        Tracer.out(" error: item IDs do not match");
                        Pop_Up.getInstance().alert("Error when processing gift: item IDs do not match");
                        return;
                    };
                    callback();
                    user.add_to_decor_inventory(_local3, _local2.data.userDecorId);
                } else
                {
                    Tracer.out(("DataManager > send_thank_you_gift : KO : " + _local2.message));
                    fail_callback();
                    Pop_Up.getInstance().display_popup(Pop_Up.ALERT, "Sorry, there was an error when trying to send this thank-you gift - please try again!");
                };
            };
            var path:String = (Constants.SERVER_SERVICES + "send_thank_you_gift.php");
            Tracer.out(((("DataManager > send_thank_you_gift of item " + id) + " to user ") + recipient_id));
            var req:URLRequest = this.make_request(path);
            (req.data.recipient_id = recipient_id);
            (req.data.gift_id = id);
            var loader:URLLoader = this.make_loader();
            loader.addEventListener(Event.COMPLETE, data_loaded);
            loader.load(req);
        }
        public function accept_gift(message_id:String, item:PurchasableObject):void{
            var data_loaded:Function;
            data_loaded = function (_arg1:Event):void{
                Tracer.out((" accept_gift > received " + _arg1.target.data));
                var _local2:Object = Json.decode(_arg1.target.data);
                if (_local2.status != 0)
                {
                    Tracer.out(" error on accept_gift; bailing");
                    return;
                };
                if ((item is Item))
                {
                    if (item.id != _local2.data.Item_ID)
                    {
                        Tracer.out(" error: item IDs do not match");
                        Pop_Up.getInstance().alert("Error when accepting gift: item IDs do not match");
                        return;
                    };
                    item.addAcceptGiftParams(_local2.data);
                    user.add_to_closet((item as Item));
                } else
                {
                    if ((item is Decor))
                    {
                        item.addAcceptGiftParams(_local2.data);
                        user.accept_decor_gift((item as Decor), _local2.data.userDecorId);
                    };
                };
            };
            Tracer.out(("DataManager > accept_gift: message_id = " + message_id));
            var request:URLRequest = this.make_request((Constants.SERVER_SERVICES + "accept_gift.php"));
            (request.data.message_id = message_id);
            (request.data.type = (((item is Item)) ? "item" : "decor"));
            var loader:URLLoader = this.make_loader();
            loader.addEventListener(Event.COMPLETE, data_loaded);
            loader.load(request);
        }
        public function greet_friend(message_id:int):void{
            var data_loaded:Function;
            data_loaded = function (_arg1:Event):void{
                Tracer.out(("DataManager > greet_friend : received " + _arg1.target.data));
            };
            var path:String = (Constants.SERVER_SERVICES + "greet_friend.php");
            Tracer.out(("DataManager > greet_friend : message_id is " + message_id));
            var req:URLRequest = this.make_request(path);
            (req.data.message_id = message_id);
            var loader:URLLoader = this.make_loader();
            loader.addEventListener(Event.COMPLETE, data_loaded);
            loader.load(req);
        }
        public function reward_free_offer_item(item_id:int):void{
            var data_loaded:Function;
            data_loaded = function (_arg1:Event):void{
                var _local2:Object = Json.decode(_arg1.target.data);
                if (_local2.status == 0)
                {
                    Tracer.out("DataManager > reward_free_offer_item : ok");
                    (user.daily_sponsored_item = true);
                } else
                {
                    Tracer.out(("DataManager > reward_free_offer_item : KO : " + _local2.message));
                };
            };
            var path:String = (Constants.SERVER_SERVICES + "reward_free_offer_item.php");
            Tracer.out(("DataManager > reward_free_offer_item : " + item_id));
            var req:URLRequest = this.make_request(path);
            (req.data.item_id = item_id);
            var loader:URLLoader = this.make_loader();
            loader.addEventListener(Event.COMPLETE, data_loaded);
            loader.load(req);
        }
        public function buy_item(item:Item):void{
            var buyItemComplete:Function;
            var purchase_section:String;
            var xml_req:URLRequest;
            var loader:URLLoader;
            buyItemComplete = function (_arg1:Event):void{
                Tracer.out(("event.target.data is " + _arg1.target.data));
                if (_arg1.target.data == Errors.E_USER_INSUFFICIENT_FUNDS)
                {
                    Pop_Up.getInstance().display_popup(Pop_Up.NEED_MORE_CASH);
                    check_user_balances();
                    return;
                };
                if (_arg1.target.data == -5)
                {
                    Pop_Up.getInstance().display_insufficient_level();
                    return;
                };
                if (_arg1.target.data == -6)
                {
                    Pop_Up.getInstance().display_popup(Pop_Up.ALREADY_OWN, item);
                    return;
                };
                var _local2:URLVariables = new URLVariables(_arg1.target.data);
                Tracer.out(("DataManager > buy_item.php shopping = " + _local2.shopping));
                if (_local2.shopping == "false")
                {
                    Pop_Up.getInstance().display_popup(Pop_Up.ALREADY_OWN, item);
                } else
                {
                    if (_local2.shopping == "true")
                    {
                        check_user_balances();
                        user.do_item_purchase();
                        if (main.current_section == "boutique")
                        {
                            if (((user.first_time_visit()) && ((Tracker.first_time_buy_item == false))))
                            {
                                (Tracker.first_time_buy_item = true);
                                Tracker.track_first_time(Tracker.BUY_ITEM);
                                if (UserData.getInstance().boutique == null)
                                {
                                    EventHandler.getInstance().queue_my_boutique_start();
                                };
                            };
                        };
                        //Pop_Up.getInstance().display_popup(Pop_Up.BUY_ITEM_CONFIRM, item);
						Pop_Up.getInstance().HideCloseButton();
                    };
                };
            };
            if (int(item.price) > this.user.fcash)
            {
                Pop_Up.getInstance().display_popup(Pop_Up.NEED_MORE_CASH);
            } else
            {
                purchase_section = this.main.current_section;
                xml_req = this.make_request((Constants.SERVER_SERVICES + "buy_item.php"));
                (xml_req.data.itemid = item.id);
                if (Main.getInstance().current_section == Constants.SECTION_BOUTIQUE_VISIT)
                {
                    (xml_req.data.reseller_id = BoutiqueVisit.getInstance().user_id);
                };
                Tracer.out(((("DataManager > calling buy_item.php, itemid = " + item.id) + ", user_id=") + user_id));
                loader = this.make_loader();
                loader.addEventListener(Event.COMPLETE, buyItemComplete);
                loader.load(xml_req);
            };
        }
        public function buy_look_of_the_day(id:int, cost:int, items:Vector.<Item>):void{
            var buyLotdComplete:Function;
            var xml_req:URLRequest;
            var loader:URLLoader;
            buyLotdComplete = function (_arg1:Event):void{
                Tracer.out(("event.target.data is " + _arg1.target.data));
                if (_arg1.target.data == Errors.E_USER_INSUFFICIENT_FUNDS)
                {
                    Pop_Up.getInstance().display_popup(Pop_Up.NEED_MORE_CASH);
                    check_user_balances();
                    return;
                };
                var _local2:int = items.length;
                var _local3:UserData = UserData.getInstance();
                var _local4:int;
                while (_local4 < _local2)
                {
                    _local3.add_to_closet(items[_local4]);
                    _local4++;
                };
                check_user_balances();
            };
            if (int(cost) > this.user.fcash)
            {
                Pop_Up.getInstance().display_popup(Pop_Up.NEED_MORE_CASH);
            } else
            {
                xml_req = this.make_request((Constants.SERVER_SERVICES + "buy_look_of_the_day.php"));
                (xml_req.data.look_id = id);
                Tracer.out(((("DataManager > calling buy_look_of_the_day.php, lookid = " + id) + ", user_id=") + user_id));
                loader = this.make_loader();
                loader.addEventListener(Event.COMPLETE, buyLotdComplete);
                loader.load(xml_req);
            };
        }
        public function buy_for_friend(friend_id:String, item:PurchasableObject, callback:Function=null, fail_callback:Function=null):void{
            var request:URLRequest;
            var loader:URLLoader;
            var autoDelete:Boolean;
            if (item.price <= this.user.fcash)
            {
                var data_loaded:Function = function (_arg1:Event):void{
                    Tracer.out(("buy_for_friend: received " + _arg1.target.data));
                    var _local2:Object = Json.decode(_arg1.target.data);
                    if (_local2.status == 0)
                    {
                        check_user_balances();
                        Pop_Up.getInstance().display_popup(Pop_Up.FRIEND_BUY_CONFIRM);
                        if (callback != null)
                        {
                            callback();
                        };
                    } else
                    {
                        Tracer.out("Buy for friend failed!");
                        if (_local2.status == Errors.E_USER_INSUFFICIENT_FUNDS)
                        {
                            Pop_Up.getInstance().display_popup(Pop_Up.NEED_MORE_CASH);
                            check_user_balances();
                        } else
                        {
                            if (_local2.status == -6)
                            {
                                Pop_Up.getInstance().display_popup(Pop_Up.FRIEND_ALREADY_HAS);
                            } else
                            {
                                Pop_Up.getInstance().display_popup(Pop_Up.ALERT, "Sorry, there was an error when trying to buy this item - please try again!");
                            };
                        };
                        if (fail_callback != null)
                        {
                            fail_callback();
                        };
                    };
                };
                request = this.make_request((Constants.SERVER_SERVICES + "buy_for_friend.php"));
                (request.data.itemid = String(item.id));
                (request.data.friend_id = friend_id);
                (request.data.type = (((item is Item)) ? "item" : "decor"));
                Tracer.out((((((((((("calling " + Constants.SERVER_SERVICES) + "buy_for_friend.php") + "  itemid = ") + item.id) + ", friend_id = ") + friend_id) + ", user_id = ") + user_id) + ", type = ") + request.data.type));
                loader = this.make_loader();
                loader.addEventListener(Event.COMPLETE, data_loaded);
                loader.load(request);
            } else
            {
                Pop_Up.getInstance().display_popup(Pop_Up.NEED_MORE_CASH);
                if (fail_callback != null)
                {
                    autoDelete = false;
                    (fail_callback(autoDelete));
                };
            };
        }
        public function give_to_friend(recipient_id:String, item_id:int, callback:Function, fail_callback:Function){
            var data_loaded:Function;
            data_loaded = function (_arg1:Event):void{
                var _local2:Object = Json.decode(_arg1.target.data);
                if (_local2.status == 0)
                {
                    Tracer.out("DataManager > give_free_item : OK");
                    callback();
                } else
                {
                    Tracer.out(("DataManager > give_free_item : KO : " + _local2.message));
                    fail_callback();
                };
            };
            var path:String = (Constants.SERVER_SERVICES + "give_free_item.php");
            Tracer.out(((("DataManager > give_free_item " + recipient_id) + ", item ") + item_id));
            var req:URLRequest = this.make_request(path);
            (req.data.item_id = item_id);
            (req.data.recipient_id = recipient_id);
            var loader:URLLoader = this.make_loader();
            loader.addEventListener(Event.COMPLETE, data_loaded);
            loader.load(req);
        }
       public function ask_friend(friend_id:String, item:PurchasableObject):void{
            var onComplete:Function;
            onComplete = function (_arg1:Event):void{
                var _local2:Object = Json.decode(_arg1.target.data);
              	if (_local2.status == 0)
                {
                   // Pop_Up.getInstance().display_popup(Pop_Up.FRIEND_REQUEST_CONFIRM);
                } else
                {
                   // Pop_Up.getInstance().display_popup(Pop_Up.ALERT, "Sorry, there was an error when trying to request this item - please try again later!");
                };
            };
            var req:URLRequest = this.make_request((Constants.SERVER_SERVICES + "ask_friend.php"));
            (req.data.itemid = item.id);
            (req.data.friend_id = friend_id);
            (req.data.type = (((item is Item)) ? "item" : "decor"));
            var loader:URLLoader = this.make_loader();
            loader.addEventListener(Event.COMPLETE, onComplete);
            loader.load(req);
        }
        public function request_item(item_id:int):void{
            var data_loaded:Function;
            data_loaded = function (_arg1:Event):void{
                Tracer.out(("  request_item response : " + _arg1.target.data));
                var _local2:Object = Json.decode(_arg1.target.data);
                if (_local2.status == 0)
                {
                    Tracer.out("DataManager > request_item : OK");
                } else
                {
                    Tracer.out(("DataManager > request_item : KO : " + _local2.message));
                    Pop_Up.getInstance().display_popup(Pop_Up.ALERT, "Sorry, there was an error when trying to generate this request - please try again later!");
                };
            };
            var path:String = (Constants.SERVER_SERVICES + "request_item.php");
            Tracer.out(("DataManager > request_item " + item_id));
            var req:URLRequest = this.make_request(path);
            (req.data.item_id = item_id);
            var loader:URLLoader = this.make_loader();
            loader.addEventListener(Event.COMPLETE, data_loaded);
            loader.load(req);
        }
        public function request_free_item(item_id:int):void{
            var data_loaded:Function;
            data_loaded = function (_arg1:Event):void{
                Tracer.out(("  request_free_item response : " + _arg1.target.data));
                var _local2:Object = Json.decode(_arg1.target.data);
                if (_local2.status == 0)
                {
                    Tracer.out("DataManager > request_free_item : OK");
                    (user.daily_free_request = true);
                    External.showAppssavvy(External.AS_REQUEST_FREE);
                } else
                {
                    Tracer.out(("DataManager > request_free_item : KO : " + _local2.message));
                    if (_local2.status == Errors.E_DAILY_LIMIT_EXCEEDED)
                    {
                        Pop_Up.getInstance().display_popup(Pop_Up.ALERT, "Oops!\nYou've already requested your free item for today");
                    } else
                    {
                        Pop_Up.getInstance().display_popup(Pop_Up.ALERT, "Sorry, there was an error when trying to request this item for free - please try again later!");
                    };
                };
            };
            //var path:String = (Constants.SERVER_SERVICES + "request_free_item.php");
			var path:String = ("http://viroxoty.com/testing/protected/services/request_free_item.php");
            Tracer.out(("DataManager > request_free_item >path " + path));
			Tracer.out(("DataManager > request_free_item " + item_id));
            var req:URLRequest = this.make_request(path);
            (req.data.item_id = item_id);
            var loader:URLLoader = this.make_loader();
            loader.addEventListener(Event.COMPLETE, data_loaded);			
            loader.load(req);
        }
        public function buy_entry():void{
            (this.buy_looks_over_limit = true);
            this.submit_look(this.cur_avatar_controller, true);
        }
        public function submit_look(_arg1:AvatarController, _arg2:Boolean=false):void{
            var _local3:int = ((this.buy_looks_over_limit) ? 50 : 0);
            if ((((this.user.fcash < _local3)) && ((this.user.fcash >= 0))))
            {
                (this.cur_avatar_controller = _arg1);
                Pop_Up.getInstance().display_popup(Pop_Up.NEED_MORE_CASH);
                return;
            };
            (this.get_enter_look_reward = !((this.buy_looks_over_limit == true)));
            (this.tries_png_save = 0);
            (this.avatar_item_ids = _arg1.get_avatar_item_ids());
            (this.avatar_styles = _arg1.styles);
            Tracer.out(("DataManager > submit_look: avatar_item_ids = " + this.avatar_item_ids));
            this.save_png(_arg1, _arg2);
        }
		
		
		public function save_png(avatar_controller:AvatarController, use_last:Boolean = false):void {
			var header:URLRequestHeader = new URLRequestHeader("Content-type","application/octet-stream");
			//var png_url:URLRequest = new URLRequest(Constants.SERVER_SERVICES + "png_encoder.php?client_key=" + client_key + "&session="+fb_session+"&user_id="+user_id);
			var png_url:URLRequest = new URLRequest("http://viroxotystudios.com/testing/protected/services/png_encoder.php?client_key=" + client_key + "&session="+fb_session+"&user_id="+user_id);
			//var png_url:URLRequest = new URLRequest("http://viroxoty.com/testing/protected/services/png_encoder.php?client_key=" + client_key + "&session="+fb_session+"&user_id="+user_id);
			png_url.requestHeaders.push(header);
			png_url.method = URLRequestMethod.POST;
			
			png_url.data = PNGGenerator.generate_look_png(avatar_controller);

			var png_loader:URLLoader = new URLLoader();
			png_loader.addEventListener(Event.COMPLETE, image_loader_complete);
			png_loader.addEventListener(IOErrorEvent.IO_ERROR, image_loader_error);
			png_loader.load(png_url);

			function image_loader_complete(evt:Event):void {
				Tracer.out("image_loader_complete > "+evt.target.data);
				var o:Object = com.adobe.serialization.json.JSON.decode(String(evt.target.data));
				if (o.status == 0) {
					Tracer.out("image_loader_complete > png_encoded succesfully wrote image file to server");
					enter_contest(avatar_controller, use_last, o.data.filename);
				} else {
					tries_png_save++;
					Tracer.out("image_loader_complete > failed write.  Tries: "+tries_png_save);
					if (tries_png_save < 3) {
						save_png(avatar_controller);
					} else {
						MainViewController.getInstance().hide_preloader();
			
						// give up with an alert
						Pop_Up.getInstance().display_popup(Pop_Up.ALERT, "Oops!  Server error on entering contest, please try again later!");
					}
				}
			}

			function image_loader_error(event:Event):void {
				tries_png_save++;
				Tracer.out("png_encoder.php > Error occured.  Tries: "+tries_png_save);
				if (tries_png_save < 3) {
					save_png(avatar_controller);
				} else {
					// give up with an alert
					Pop_Up.getInstance().display_popup(Pop_Up.ALERT, "Oops!  Server error on entering contest, please try again later!");
				}
			}
		}
        /*public function save_png(avatar_controller:AvatarController, use_last:Boolean=false):void{
            var image_loader_complete:Function;
            var image_loader_error:Function;
            image_loader_complete = function (_arg1:Event):void{
                Tracer.out(("image_loader_complete > " + _arg1.target.data));
                var _local2:Object = Json.decode(String(_arg1.target.data));
                if (_local2.status == 0)
                {
                    Tracer.out("image_loader_complete > png_encoded succesfully wrote image file to server");
                    enter_contest(avatar_controller, use_last, _local2.data.filename);
                } else
                {
                    tries_png_save++;
                    Tracer.out(("image_loader_complete > failed write.  Tries: " + tries_png_save));
                    if (tries_png_save < 3)
                    {
                        save_png(avatar_controller);
                    } else
                    {
                        MainViewController.getInstance().hide_preloader();
                        Pop_Up.getInstance().display_popup(Pop_Up.ALERT, "Oops!  Server error on entering contest, please try again later!");
                    };
                };
            };
            image_loader_error = function (_arg1:Event):void{
                tries_png_save++;
                Tracer.out(("png_encoder.php > Error occured.  Tries: " + tries_png_save));
				Tracer.out(("png_encoder.php > Error occured.  Error: " + _arg1));
                if (tries_png_save < 3)
                {
                    save_png(avatar_controller);
                } else
                {
                    Pop_Up.getInstance().display_popup(Pop_Up.ALERT, "Oops!  Server error on entering contest, please try again later!");
                };
            };
            var header:URLRequestHeader = new URLRequestHeader("Content-type", "application/octet-stream");
            //var png_url:URLRequest = new URLRequest(((((Constants.SERVER_SERVICES + "png_encoder.php?client_key=") + this.client_key) + "&session=") + this.fb_session));
			var png_url:URLRequest = new URLRequest(((((Constants.SERVER_SERVICES + "png_encoder.php?client_key=") + this.client_key) + "&session=") + this.fb_session));
			
            png_url.requestHeaders.push(header);
            (png_url.method = URLRequestMethod.POST);
            (png_url.data = PNGGenerator.generate_look_png(avatar_controller));
            var png_loader:URLLoader = new URLLoader();
            png_loader.addEventListener(Event.COMPLETE, image_loader_complete);
            png_loader.addEventListener(IOErrorEvent.IO_ERROR, image_loader_error);
            png_loader.load(png_url);
        }*/
        function enter_contest(avatar_controller:AvatarController, use_last:Boolean, avatar_name:String){
            var variables:URLVariables;
            var s:String;
            var onComplete:Function;
            var key:String;
            var pi:String;
            onComplete = function (event:Event):void{
                Tracer.out(("enter_contest.php returned: " + event.target.data));
                MainViewController.getInstance().hide_preloader();
                var cs:String = Main.getInstance().current_section;
                var o:Object = Json.decode(String(event.target.data));
                if (o.status == 0)
                {
                    (user.last_avatar_id = o.data.avatar_id);
                    if (get_enter_look_reward)
                    {
                        (user.pending_fcash_reward = Constants.ENTER_LOOK_REWARD);
                        check_user_balances();
                    };
                    if (use_last)
                    {
                        (variables.items = last_look.items);
                        (variables.pet_swfs = last_look.pet_swfs);
                        (variables.pet_categories = last_look.pet_categories);
                    } else
                    {
                        (variables.items = avatar_controller.get_avatar_items());
                        (variables.pet_swfs = avatar_controller.get_pet_swfs());
                        (variables.pet_categories = avatar_controller.get_pet_categories());
                    };
                    Runway.getInstance().addUserLook(variables, user.last_avatar_id);
                    FaceoffController.getInstance().just_entered_look(user.last_avatar_id);
                    if (cs == Constants.SECTION_DRESSING_ROOM)
                    {
                        Pop_Up.getInstance().display_popup(Pop_Up.ENTER_LOOK_CONFIRM);
                    } else
                    {
                        if (cs == Constants.SECTION_MY_BOUTIQUE)
                        {
                            Pop_Up.getInstance().display_popup(Pop_Up.ENTER_LOOK_CONFIRM_MB);
                        };
                    };
                    Tracer.out(("user.didGetBestDressed is " + user.didGetBestDressed));
                    if (user.didGetBestDressed == false)
                    {
                        GameTimer.getInstance().registerForSingleEvent(Constants.BEST_DRESSED_DELAY_SECS, check_best_dressed);
                    };
                    return;
                };
                if (cs == Constants.SECTION_DRESSING_ROOM)
                {
                    DressingRoom.getCurrentInstance().check_show_enter_look();
                } else
                {
                    if (cs == Constants.SECTION_MY_BOUTIQUE)
                    {
                        MyBoutique.getInstance().check_show_enter_look();
                    };
                };
                if (o.status == -1)
                {
                    Tracer.out("Enter contest: general error");
                    Pop_Up.getInstance().display_popup(Pop_Up.ALERT, "enter contest - general error");
                } else
                {
                    if (o.status == -2)
                    {
                        try
                        {
                            Tracer.out("Maximum looks/day exceeded");
                            Pop_Up.getInstance().display_popup(Pop_Up.LOOKS_LIMIT);
                        } catch(e:Error)
                        {
                            Tracer.out(("Maximum looks/day exceeded.  Error: " + e.toString()));
                        };
                    } else
                    {
                        if (o.status == -3)
                        {
                            Pop_Up.getInstance().display_popup(Pop_Up.DUPLICATE_LOOK);
                        } else
                        {
                            if (o.status == Errors.E_USER_INSUFFICIENT_FUNDS)
                            {
                                Pop_Up.getInstance().display_popup(Pop_Up.NEED_MORE_CASH);
                                check_user_balances();
                            } else
                            {
                                if (o.status == Errors.E_NO_ITEMS_FOR_LOOK)
                                {
                                    Pop_Up.getInstance().alert("Error: No items for this look; known issue to be resolved");
                                    send_alert("No items received by enter_contest.php");
                                } else
                                {
                                    Tracer.out("Enter contest: unexpected error");
                                    Pop_Up.getInstance().display_popup(Pop_Up.ALERT, "Server Error, we're looking into it.");
                                };
                            };
                        };
                    };
                };
            };
            (this.user.last_avatar_id = -1);
            var request:URLRequest = this.make_request((Constants.SERVER_SERVICES + "enter_contest.php"));
            variables = (request.data as URLVariables);
            if (use_last)
            {
                for (var _local7 in this.last_look)
                {
                    key = _local7;
                    _local7;
                    (variables[key] = this.last_look[key]);
                };
            } else
            {
                (variables.itemids = this.avatar_item_ids);
                if (variables.itemids == null)
                {
                    (variables.itemids = "");
                };
                (variables.styles = ((((this.avatar_styles.hair + ",") + this.avatar_styles.eyes) + ",") + this.avatar_styles.lips));
                (variables.colors = ((((this.avatar_styles.hair_color + ",") + this.avatar_styles.eye_color) + ",") + this.avatar_styles.lip_color));
                (variables.skintone = this.avatar_styles.skin);
                (variables.eyeshade = this.avatar_styles.eye_shade);
                (variables.eyebrows = this.avatar_styles.eyebrows);
                (variables.blush = this.avatar_styles.blush);
                pi = avatar_controller.get_pet_items();
                if (pi != "")
                {
                    (variables.pet_items = pi);
                };
                (this.last_look = new Object());
                for (_local7 in variables)
                {
                    key = _local7;
                    _local7;
                    (this.last_look[key] = variables[key]);
                };
                (this.last_look.pet_swfs = avatar_controller.get_pet_swfs());
                (this.last_look.pet_categories = avatar_controller.get_pet_categories());
                (this.last_look.items = avatar_controller.get_avatar_items());
            };
            (variables.contestid = TopMenu.get_contest_id());
            (variables.buy = this.buy_looks_over_limit);
            (variables.png_name = avatar_name);
            (request.data = variables);
            Tracer.out(((" sending data to " + Constants.SERVER_SERVICES) + "enter_contest.php"));
            for (_local7 in variables)
            {
                s = _local7;
                _local7;
                Tracer.out(((("   " + s) + " = ") + variables[s]));
            };
            if ((((variables.itemids == "")) || ((variables.itemids == null))))
            {
                Tracer.out("DataManager > enter_contest: ERROR no items");
            };
            var loader:URLLoader = this.make_loader();
            loader.addEventListener(Event.COMPLETE, onComplete);
            loader.load(request);
        }
        public function publish_wall(id:int, type:String):void{
            var onComplete:Function;
            onComplete = function (_arg1:Event):void{
                Tracer.out(("DataManager > publish_wall : " + _arg1.target.data));
                var _local2:Object = Json.decode(String(_arg1.target.data));
                if (_local2.status == 0)
                {
                    External.showAppssavvy(External.AS_SHARE_WALL);
                };
            };
            var req:URLRequest = this.make_request((Constants.SERVER_SERVICES + "publish_wall.php"));
            (req.data.id = id);
            (req.data.type = type);
            var loader:URLLoader = this.make_loader();
            loader.addEventListener(Event.COMPLETE, onComplete);
            loader.load(req);
        }
        public function buy_vote():void{
            Tracer.out("DataManager > buy_vote");
            if (this.user.fcash >= Constants.COST_BUY_VOTE)
            {
                (this.buy_votes_over_limit = true);
                this.register_vote(this.last_vote.id, this.last_vote.vote_num, this.last_vote.uid, this.last_vote.obj);
            } else
            {
                Pop_Up.getInstance().display_popup(Pop_Up.NEED_MORE_CASH);
            };
        }
        public function register_vote(id:String, vote_num:Number, uid:String, obj:Object):void{
            var avatarVoteComplete:Function;
            avatarVoteComplete = function (_arg1:Event):void{
                Tracer.out(("DataManager > avatarVoteComplete : " + _arg1.target.data));
                var _local2:Object = Json.decode(String(_arg1.target.data));
                if (_local2.status == 0)
                {
                    if (buy_votes_over_limit == false)
                    {
                        (user.pending_fcash_reward = Constants.VOTE_REWARD);
                    };
                    check_user_balances();
                    Runway.getInstance().add_votes(last_vote.id, last_vote.vote_num, last_vote.uid);
                    (last_vote = null);
                } else
                {
                    if (_local2.status == "-1")
                    {
                        Tracer.out("General Error");
                        Pop_Up.getInstance().display_popup(Pop_Up.ALERT, "Sorry, there was an error when voting - please try again!");
                    } else
                    {
                        if (_local2.status == Errors.E_USER_INSUFFICIENT_FUNDS)
                        {
                            Tracer.out("Insufficient Funds");
                            Pop_Up.getInstance().display_popup(Pop_Up.NEED_MORE_CASH);
                        } else
                        {
                            if (_local2.status == "1")
                            {
                                Pop_Up.getInstance().display_popup(Pop_Up.ALREADY_VOTED);
                            } else
                            {
                                if (_local2.status == "2")
                                {
                                    Pop_Up.getInstance().display_popup(Pop_Up.VOTE_LIMIT);
                                };
                            };
                        };
                    };
                };
            };
            if (((this.user.first_time_visit()) && ((Tracker.first_time_vote == false))))
            {
                (Tracker.first_time_vote = true);
                Tracker.track_first_time(Tracker.VOTE);
            };
            (this.last_vote = new Object());
            (this.last_vote.id = id);
            (this.last_vote.vote_num = vote_num);
            (this.last_vote.uid = uid);
            (this.last_vote.obj = obj);
            var req:URLRequest = this.make_request((Constants.SERVER_SERVICES + "avatar_vote.php"));
            (req.data.contestid = TopMenu.get_contest_id());
            (req.data.avatar_id = id);
            (req.data.value = vote_num);
            (req.data.buy = this.buy_votes_over_limit);
            Tracer.out((("calling " + Constants.SERVER_SERVICES) + "avatar_vote.php"));
            (this.send_data = new Object());
            (this.send_data.obj = obj);
            var loader:URLLoader = this.make_loader();
            loader.addEventListener(Event.COMPLETE, avatarVoteComplete);
            loader.load(req);
        }
        public function track_game_event(event:String, target:String=null):void{
            var track_complete:Function;
            track_complete = function (_arg1:Event):void{
                if (_arg1.target.data == -1)
                {
                    Tracer.out("track: general error");
                    Pop_Up.getInstance().display_popup(Pop_Up.ALERT, "track - general error");
                } else
                {
                    if (_arg1.target.data == 0)
                    {
                        Tracer.out("track: success");
                    } else
                    {
                        Tracer.out(("track() returned : " + _arg1.target.data));
                    };
                };
            };
            Tracer.out(((((("calling track_game_event for event " + event) + ", target ") + target) + ", user_id ") + user_id));
           /* var request:URLRequest = this.make_request((Constants.SERVER_SERVICES + "track.php"));
            (request.data.event = event);
            if (target)
            {
                (request.data.target = target);
            };
            var loader:URLLoader = this.make_loader();
            loader.addEventListener(Event.COMPLETE, track_complete);
            loader.load(request);*/
        }
        public function track_daily_free_gift():void{
            var data_loaded:Function;
            data_loaded = function (_arg1:Event):void{
                Tracer.out((" track_daily_free_gift > received " + _arg1.target.data));
            };
            var request:URLRequest = this.make_request((Constants.SERVER_SERVICES + "track_give_free_item.php"));
            var loader:URLLoader = this.make_loader();
            loader.addEventListener(Event.COMPLETE, data_loaded);
            loader.load(request);
        }
		public function save_user_default_avatar(items:String, style:String, pet_items:String = null):void {
			Tracer.out("DataManager > save_user_avatar: items = "+items+" ;  style = "+style+" ;  pet_items = "+pet_items);
			
			var request:URLRequest = make_request(Constants.SERVER_SERVICES + "save_user_avatar.php");
			request.data.items = items;
			request.data.style = style;
			if (pet_items)
				request.data.pet_items = pet_items;

			var loader:URLLoader = make_loader();
			loader.addEventListener(Event.COMPLETE, data_loaded);
			loader.load(request);
			
			function data_loaded(event:Event):void {
				Tracer.out(" save_user_avatar > received "+event.target.data);
			}
		}
        /*public function save_user_default_avatar(items:String, style:String, pet_items:String=null):void{
            var data_loaded:Function;
            data_loaded = function (_arg1:Event):void{
                Tracer.out((" save_user_avatar > received " + _arg1.target.data));
            };
            Tracer.out(((((("DataManager > save_user_avatar: items = " + items) + " ;  style = ") + style) + " ;  pet_items = ") + pet_items));
            var request:URLRequest = this.make_request((Constants.SERVER_SERVICES + "save_user_avatar.php"));
            (request.data.items = items);
            (request.data.style = style);
            if (pet_items)
            {
                (request.data.pet_items = pet_items);
            };
            var loader:URLLoader = this.make_loader();
            loader.addEventListener(Event.COMPLETE, data_loaded);
            loader.load(request);
        }*/
        public function process_gift_requests(request_id:String, users:Array, item_id:int, gift_type:String):void{
            var data_loaded:Function;
            data_loaded = function (_arg1:Event):void{
                Tracer.out((" process_gift_requests > received " + _arg1.target.data));
            };
            Tracer.out(((((("DataManager > process_gift_requests: request_id = " + request_id) + " ;  item_id = ") + item_id) + " ;  gift_type = ") + gift_type));
            var request:URLRequest = this.make_request((Constants.SERVER_SERVICES + "process_gift_requests.php"));
            (request.data.request_id = request_id);
            (request.data.users = users.toString());
            (request.data.item_id = item_id);
            (request.data.gift_type = gift_type);
            var loader:URLLoader = this.make_loader();
            loader.addEventListener(Event.COMPLETE, data_loaded);
            loader.load(request);
        }
        public function add_to_a_list(uid:String, username:String, success_callback:Function=null, fail_callback:Function=null, buy:Boolean=false):void{
            var data_loaded:Function;
            data_loaded = function (_arg1:Event):void{
                Tracer.out(("DataManager > add_to_a_list: received " + _arg1.target.data));
                var _local2:Object = Json.decode(_arg1.target.data);
                if (_local2.status == 0)
                {
                    Tracer.out("DataManager > add_to_a_list : ok");
                    user.add_to_a_list(uid, username);
                    if (success_callback != null)
                    {
                        success_callback();
                    };
                    if (((buy) || (buy_invites_over_limit)))
                    {
                        check_user_balances();
                    };
                } else
                {
                    Tracer.out(("DataManager > add_to_a_list : KO : " + _local2.message));
                    if (_local2.status == Errors.E_MAX_A_LIST_ADDITIONS)
                    {
                        Tracer.out("max free a list invites exceeded");
                        Pop_Up.getInstance().display_popup(Pop_Up.A_LIST_LIMIT);
                        if (fail_callback != null)
                        {
                            fail_callback();
                        };
                        return;
                    };
                    if (_local2.status == Errors.E_ALREADY_ON_A_LIST)
                    {
                        user.add_to_a_list(uid, username);
                        Tracer.out((("uid " + uid) + " was already on your A-List"));
                        if (success_callback != null)
                        {
                            success_callback();
                        };
                    };
                };
            };
            Tracer.out(((("DataManager > add_to_a_list: uid = " + uid) + ", success_callback = ") + success_callback));
            (this.last_invite = {
                "uid":uid,
                "username":username,
                "success_callback":success_callback,
                "fail_callback":fail_callback
            });
            var request:URLRequest = this.make_request((Constants.SERVER_SERVICES + "add_to_a_list.php"));
            (request.data.target_id = uid);
            if (((buy) || (this.buy_invites_over_limit)))
            {
                (request.data.buy = true);
            };
            var loader:URLLoader = this.make_loader();
            loader.addEventListener(Event.COMPLETE, data_loaded);
            loader.load(request);
        }
        public function buy_a_list_invite():void{
            if (this.user.fcash >= Constants.COST_A_LIST_INVITE)
            {
                (this.buy_invites_over_limit = true);
                Tracer.out(("buy_a_list_invite > last_invite.uid = " + this.last_invite.uid));
                this.add_to_a_list(this.last_invite.uid, this.last_invite.username, this.last_invite.success_callback, this.last_invite.fail_callback, true);
            } else
            {
                Pop_Up.getInstance().display_popup(Pop_Up.NEED_MORE_CASH);
            };
        }
        public function accept_a_list_invite(uid:String, username:String, success_callback:Function=null, fail_callback:Function=null):void{
            var data_loaded:Function;
            data_loaded = function (_arg1:Event):void{
                Tracer.out(("DataManager > accept_a_list_invite: received " + _arg1.target.data));
                var _local2:Object = Json.decode(_arg1.target.data);
                if (_local2.status == 0)
                {
                    Tracer.out("DataManager > accept_a_list_invite : ok");
                    user.add_to_a_list(uid, username);
                    if (success_callback != null)
                    {
                        success_callback();
                    };
                    (user.pending_fcash_reward = Constants.A_LIST_ADD_REWARD);
                    check_user_balances();
                    MessageCenter.getInstance().updateFCash(Constants.A_LIST_ADD_REWARD);
                    user.accept_a_list(uid);
                } else
                {
                    Tracer.out(("DataManager > accept_a_list_invite : KO : " + _local2.message));
                    if (_local2.status == Errors.E_ALREADY_ON_A_LIST)
                    {
                        user.add_to_a_list(uid, username);
                        Tracer.out((("uid " + uid) + " was already on your A-List"));
                        if (success_callback != null)
                        {
                            success_callback();
                        };
                    } else
                    {
                        if (fail_callback != null)
                        {
                            fail_callback();
                        };
                    };
                };
            };
            Tracer.out(((("DataManager > accept_a_list_invite: uid = " + uid) + ", success_callback = ") + success_callback));
            var request:URLRequest = this.make_request((Constants.SERVER_SERVICES + "accept_a_list_invite.php"));
            (request.data.sender_id = uid);
            var loader:URLLoader = this.make_loader();
            loader.addEventListener(Event.COMPLETE, data_loaded);
            loader.load(request);
        }
        public function remove_from_a_list(uid:String, success_callback:Function=null, fail_callback:Function=null):void{
            var request:URLRequest;
            var loader:URLLoader;
            var data_loaded:Function;
            data_loaded = function (_arg1:Event):void{
                var _local2:Object;
                Tracer.out(("DataManager > remove_from_a_list: received " + _arg1.target.data));
                _local2 = Json.decode(_arg1.target.data);
                if (_local2.status == 0)
                {
                    Tracer.out("DataManager > remove_from_a_list : ok");
                    user.remove_from_a_list(uid);
                    if (success_callback != null)
                    {
                        success_callback();
                    };
                } else
                {
                    Tracer.out(("DataManager > remove_from_a_list : KO : " + _local2.message));
                    if (fail_callback != null)
                    {
                        fail_callback();
                    };
                };
            };
            Tracer.out(("DataManager > remove_from_a_list: uid = " + uid));
            request = this.make_request((Constants.SERVER_SERVICES + "remove_from_a_list.php"));
            (request.data.target_id = uid);
            loader = this.make_loader();
            loader.addEventListener(Event.COMPLETE, data_loaded);
            loader.load(request);
        }
        public function accept_a_list_reward(uid:String, success_callback:Function=null, fail_callback:Function=null):void{
            var request:URLRequest;
            var loader:URLLoader;
            var data_loaded:Function;
            data_loaded = function (_arg1:Event):void{
                var _local2:Object;
                Tracer.out(("DataManager > accept_a_list_reward: received " + _arg1.target.data));
                _local2 = Json.decode(_arg1.target.data);
                if (_local2.status == 0)
                {
                    Tracer.out("DataManager > accept_a_list_reward : ok");
                    (UserData.getInstance().pending_fcash_reward = Constants.A_LIST_ADD_REWARD);
                    check_user_balances();
                    user.accept_a_list(uid);
                    if (success_callback != null)
                    {
                        success_callback();
                    };
                } else
                {
                    Tracer.out(("DataManager > accept_a_list_reward : KO : " + _local2.message));
                    Pop_Up.getInstance().display_popup(Pop_Up.ALERT, "Server error when trying to accept A-List reward");
                    if (fail_callback != null)
                    {
                        fail_callback();
                    };
                };
            };
            Tracer.out("DataManager > accept_a_list_reward");
            request = this.make_request((Constants.SERVER_SERVICES + "accept_a_list_reward.php"));
            loader = this.make_loader();
            loader.addEventListener(Event.COMPLETE, data_loaded);
            loader.load(request);
        }
        public function join_team(team:Team, success:Function):void{
            var request:URLRequest;
            var loader:URLLoader;
            var data_loaded:Function;
            data_loaded = function (_arg1:Event):void{
                var _local2:Object;
                Tracer.out(("DataManager > join_team: received " + _arg1.target.data));
                _local2 = Json.decode(_arg1.target.data);
                if (_local2.status == 0)
                {
                    Tracer.out("DataManager > join_team : ok");
                    user.update_team(team);
                    (user.pending_points_reward = Constants.JOIN_TEAM_REWARD);
                    check_user_balances();
                    success();
                } else
                {
                    Tracer.out(("DataManager > join_team : KO : " + _local2.message));
                    Pop_Up.getInstance().display_popup(Pop_Up.ALERT, ("Server error when trying to join FashionTeam #" + team.id));
                };
            };
            Tracer.out("DataManager > join_team");
            request = this.make_request((Constants.SERVER_SERVICES + "join_team.php"));
            (request.data.team_id = team.id);
            loader = this.make_loader();
            loader.addEventListener(Event.COMPLETE, data_loaded);
            loader.load(request);
        }
        public function get_faceoff(success:Function, fail:Function, with_user:Boolean=false):void{
            var request:URLRequest;
            var loader:URLLoader;
            var data_loaded:Function;
            data_loaded = function (_arg1:Event):void{
                var _local2:Object;
                Tracer.out(("DataManager > get_faceoff: received " + _arg1.target.data));
                _local2 = Json.decode(_arg1.target.data);
                if (_local2.status == 0)
                {
                    Tracer.out("DataManager > get_faceoff : ok");
                    success(_local2.data);
                } else
                {
                    Tracer.out(("DataManager > get_faceoff : KO : " + _local2.message));
                    fail();
                };
            };
            Tracer.out(("DataManager > get_faceoff : with_user = " + with_user));
            request = this.make_request((Constants.SERVER_SERVICES + "create_faceoff.php"));
            if (with_user)
            {
                (request.data.include_id = this.user.last_avatar_id);
            };
            loader = this.make_loader();
            loader.addEventListener(Event.COMPLETE, data_loaded);
            loader.load(request);
        }
        public function judge_faceoff(faceoff_id:int, winner_id:int, success:Function):void{
            var request:URLRequest;
            var loader:URLLoader;
            var data_loaded:Function;
            data_loaded = function (_arg1:Event):void{
                var _local2:Object;
                Tracer.out(("DataManager > judge_faceoff: received " + _arg1.target.data));
                _local2 = Json.decode(_arg1.target.data);
                if (_local2.status == 0)
                {
                    Tracer.out("DataManager > judge_faceoff : ok");
                    check_user_balances();
                    success();
                } else
                {
                    Tracer.out(("DataManager > judge_faceoff : KO : " + _local2.message));
                };
            };
            Tracer.out("DataManager > judge_faceoff");
            request = this.make_request((Constants.SERVER_SERVICES + "judge_faceoff.php"));
            (request.data.faceoff_id = faceoff_id);
            (request.data.avatar_id = winner_id);
            loader = this.make_loader();
            loader.addEventListener(Event.COMPLETE, data_loaded);
            loader.load(request);
        }
        public function judge_dummy_faceoff(owner_id:String, avatar_id:int, won:Boolean):void{
            var request:URLRequest;
            var loader:URLLoader;
            var data_loaded:Function;
            data_loaded = function (_arg1:Event):void{
                var _local2:Object;
                Tracer.out(("DataManager > judge_dummy_faceoff: received " + _arg1.target.data));
                _local2 = Json.decode(_arg1.target.data);
                if (_local2.status == 0)
                {
                    Tracer.out("DataManager > judge_dummy_faceoff : ok");
                    check_user_balances();
                } else
                {
                    Tracer.out(("DataManager > judge_dummy_faceoff : KO : " + _local2.message));
                };
            };
            Tracer.out(("DataManager > judge_dummy_faceoff : won = " + won));
            request = this.make_request((Constants.SERVER_SERVICES + "judge_dummy_faceoff.php"));
            (request.data.owner_id = owner_id);
            (request.data.avatar_id = avatar_id);
            (request.data.won = ((won) ? 1 : 0));
            loader = this.make_loader();
            loader.addEventListener(Event.COMPLETE, data_loaded);
            loader.load(request);
        }
        public function send_alert(message:String):void{
            var request:URLRequest;
            var loader:URLLoader;
            var data_loaded:Function;
            data_loaded = function (_arg1:Event):void{
                var _local2:Object;
                Tracer.out(("DataManager > send_alert: received " + _arg1.target.data));
                _local2 = Json.decode(_arg1.target.data);
                if (_local2.status == 0)
                {
                    Tracer.out("DataManager > send_alert : ok");
                } else
                {
                    Tracer.out(("DataManager > send_alert : KO : " + _local2.message));
                };
            };
            Tracer.out("DataManager > send_alert");
            request = this.make_request((Constants.SERVER_SERVICES + "alert.php"));
            (request.data.message = message);
            (request.data.content = Tracer.getOutput());
            loader = this.make_loader();
            loader.addEventListener(Event.COMPLETE, data_loaded);
            loader.load(request);
        }
		/*public function get_user_boutique(initial_load:Boolean, success:Function, fail:Function):void {
			Tracer.out("DataManager > get_user_boutique");
			var request:URLRequest = make_request(Constants.SERVER_SERVICES + "get_user_boutique.php");
			
			request.data.owner_id = user_id;
			request.data.initial_load = initial_load;
			
			var loader:URLLoader = make_loader();
			loader.addEventListener(Event.COMPLETE, data_loaded);
			loader.load(request);
			
			function data_loaded(event:Event):void {
				Tracer.out("DataManager > get_user_boutique: received "+event.target.data);
				// process standard JSON reply object
				Pop_Up.getInstance().alert(event.target.data);
				var json:Object = JSON.decode(event.target.data);
				if (json.status == 0) {
					Tracer.out("DataManager > get_user_boutique : ok");
					var u:UserBoutique = new UserBoutique();
					u.parseServerData(json.data);
					user.set_user_boutique(u);
					if (success != null)
						success(u);
				} else {
					Tracer.out("DataManager > get_user_boutique : KO : "+json.message);
					if (fail != null)
						fail();
				}
			}
		}*/
        public function get_user_boutique(initial_load:Boolean, success:Function, fail:Function):void{
            var request:URLRequest;
            var loader:URLLoader;
            var data_loaded:Function;
            data_loaded = function (_arg1:Event):void{
                var _local2:Object;
                var _local3:UserBoutique;
				
				Tracer.out(("DataManager > get_user_boutique: received " + _arg1.target.data));
                _local2 = Json.decode(_arg1.target.data);
				//Pop_Up.getInstance().alert(_arg1.target.data);
				//Main.getInstance().txt11.text=_arg1.target.data;
                if (_local2.status == 0)
                {
                    Tracer.out("DataManager > get_user_boutique : ok");
                    _local3 = new UserBoutique();
                    _local3.parseServerData(_local2.data);
                    user.set_user_boutique(_local3);
                    if (success != null)
                    {
                        success(_local3);
                    };
                } else
                {
                    Tracer.out(("DataManager > get_user_boutique : KO : " + _local2.message));
                    if (fail != null)
                    {
                        fail();
                    };
                };
            };
            Tracer.out("DataManager > get_user_boutique");
            request = this.make_request((Constants.SERVER_SERVICES + "get_user_boutique.php"));
            (request.data.owner_id = user_id);
			(request.data.user_id = user_id);
            (request.data.initial_load = initial_load);
            loader = this.make_loader();
            loader.addEventListener(Event.COMPLETE, data_loaded);
            loader.load(request);
        }
        public function visit_user_boutique(visit_user_id:String, success:Function, fail:Function):void{
            var request:URLRequest;
            var loader:URLLoader;
            var data_loaded:Function;
            data_loaded = function (_arg1:Event):void{
                var _local2:Object;
                var _local3:UserBoutique;
                Tracer.out(("DataManager > visit_user_boutique: received " + _arg1.target.data));
                _local2 = Json.decode(_arg1.target.data);
                if (_local2.status == 0)
                {
                    Tracer.out("DataManager > visit_user_boutique : ok");
                    _local3 = new UserBoutique();
                    _local3.parseServerData(_local2.data);
                    if (success != null)
                    {
                        success(_local3);
                    };
                } else
                {
                    Tracer.out(("DataManager > visit_user_boutique : KO : " + _local2.message));
                    if (fail != null)
                    {
                        fail();
                    };
                };
            };
            Tracer.out(("DataManager > visit_user_boutique: owner_id = " + visit_user_id));
            request = this.make_request((Constants.SERVER_SERVICES + "get_user_boutique.php"));
            (request.data.owner_id = visit_user_id);
            (request.data.initial_load = true);
            loader = this.make_loader();
            loader.addEventListener(Event.COMPLETE, data_loaded);
            loader.load(request);
        }
        public function load_user_boutique_floor(visit_user_id:String, level:int, user_boutique:UserBoutique, success:Function, fail:Function):void{
            var request:URLRequest;
            var loader:URLLoader;
            var data_loaded:Function;
            data_loaded = function (_arg1:Event):void{
                var _local2:Object;
                Tracer.out(("DataManager > load_user_boutique_floor: received " + _arg1.target.data), false);
                _local2 = Json.decode(_arg1.target.data);
                if (_local2.status == 0)
                {
                    Tracer.out("DataManager > load_user_boutique_floor : ok");
                    user_boutique.add_floor_data(_local2.data.boutique, level);
                    if (success != null)
                    {
                        success();
                    };
                } else
                {
                    Tracer.out(("DataManager > load_user_boutique_floor : KO : " + _local2.message));
                    if (fail != null)
                    {
                        fail();
                    };
                };
            };
            Tracer.out(((("DataManager > load_user_boutique_floor: owner_id = " + visit_user_id) + ", level = ") + level));
            request = this.make_request((Constants.SERVER_SERVICES + "get_user_boutique.php"));
            (request.data.owner_id = visit_user_id);
            (request.data.level = level);
            (request.data.initial_load = false);
            loader = this.make_loader();
            loader.addEventListener(Event.COMPLETE, data_loaded);
            loader.load(request);
        }
        public function buy_decor(decor:Decor):void{
            var data_loaded:Function;
            var purchase_section:String;
            var xml_req:URLRequest;
            var loader:URLLoader;
            data_loaded = function (_arg1:Event):void{
                var _local2:Object;
                var _local3:int;
                Tracer.out(("DataManager > buy_decor: received " + _arg1.target.data));
                _local2 = Json.decode(_arg1.target.data);
                if (_local2.status == 0)
                {
                    Tracer.out("DataManager > buy_decor : ok");
                    _local3 = _local2.data.userDecorIds[0];
                    UserData.getInstance().complete_decor_purchase(decor, _local3);
                    //Pop_Up.getInstance().display_popup(Pop_Up.BUY_ITEM_CONFIRM, decor);
					Pop_Up.getInstance().HideCloseButton();
                    check_user_balances();
                } else
                {
                    Tracer.out(("DataManager > buy_decor : KO : " + _local2.message));
                    if (_local2.status == Errors.E_NO_SUCH_DECOR_ITEM)
                    {
                        Pop_Up.getInstance().alert((("Oops!  The decor item requested - id " + decor.id) + " - does not exist!"));
                    } else
                    {
                        if (_local2.status == Errors.E_USER_INSUFFICIENT_FUNDS)
                        {
                            Pop_Up.getInstance().display_popup(Pop_Up.NEED_MORE_CASH);
                            check_user_balances();
                        } else
                        {
                            if (_local2.status == Errors.E_NO_FB_SESSION)
                            {
                                Pop_Up.getInstance().alert("Oops!  Facebook Session has expired.  Please reload the page.");
                            };
                        };
                    };
                };
            };
            Tracer.out(("DataManager > buy_decor id:" + decor.id));
            if (int(decor.price) > this.user.fcash)
            {
                Pop_Up.getInstance().display_popup(Pop_Up.NEED_MORE_CASH);
            } else
            {
                purchase_section = this.main.current_section;
                xml_req = this.make_request((Constants.SERVER_SERVICES + "buy_decor.php"));
                (xml_req.data.decor_id = decor.id);
                loader = this.make_loader();
                loader.addEventListener(Event.COMPLETE, data_loaded);
                loader.load(xml_req);
            };
        }
		// debit cash to buy floor and model
		public function buy_from_cash(amount:int):void {
			
			// check if user can afford it
			if (int(amount) > user.fcash) {
				// can't afford it: show Need More Cash popup
				Pop_Up.getInstance().display_popup(Pop_Up.NEED_MORE_CASH);
			} else {
				
				var xml_req:URLRequest = make_request(Constants.SERVER_SERVICES + "nav_debitcash.php");
				xml_req.data.amount = amount.toString();
				
				var loader:URLLoader = make_loader();
				loader.addEventListener(Event.COMPLETE, data_loaded);
				loader.load(xml_req);
			}
			
			function data_loaded(event:Event):void {
				check_user_balances();
			}
		}
		
        public function buy_my_boutique_floor():void{
            var request:URLRequest;
            var loader:URLLoader;
            var data_loaded:Function;
            data_loaded = function (_arg1:Event):void{
                var _local2:Object;
                Tracer.out(("DataManager > buy_my_boutique_floor: received " + _arg1.target.data));
                _local2 = Json.decode(_arg1.target.data);
                if (_local2.status == 0)
                {
                    Tracer.out("DataManager > buy_my_boutique_floor : ok");
                    //MyBoutique.getInstance().add_floor();
                    check_user_balances();
                } else
                {
                    Tracer.out(("DataManager > buy_my_boutique_floor : KO : " + _local2.message));
                    if (_local2.status == Errors.E_USER_INSUFFICIENT_FUNDS)
                    {
                        Pop_Up.getInstance().display_popup(Pop_Up.NEED_MORE_CASH);
                        check_user_balances();
                    } else
                    {
                        if (_local2.status == Errors.E_NO_FB_SESSION)
                        {
                            Pop_Up.getInstance().alert("Oops!  Facebook Session has expired.  Please reload the page.");
                        };
                    };
                };
            };
            Tracer.out("DataManager > buy_my_boutique_floor");
            request = this.make_request((Constants.SERVER_SERVICES + "buy_my_boutique_floor.php"));
            loader = this.make_loader();
            loader.addEventListener(Event.COMPLETE, data_loaded);
            loader.load(request);
        }
        public function position_decor(userDecor:UserDecor):void{
            var request:URLRequest;
            var loader:URLLoader;
            var data_loaded:Function;
            data_loaded = function (_arg1:Event):void{
                var _local2:Object;
                Tracer.out(("DataManager > position_decor: received " + _arg1.target.data));
                _local2 = Json.decode(_arg1.target.data);
                if (_local2.status == 0)
                {
                    Tracer.out("DataManager > position_decor : ok");
                    MyBoutique.getInstance().decor_positioned(userDecor);
                } else
                {
                    Tracer.out(("DataManager > position_decor : KO : " + _local2.message));
                    if (_local2.status == Errors.E_NO_FB_SESSION)
                    {
                        Pop_Up.getInstance().alert("Oops!  Facebook Session has expired.  Please reload the page.");
                    };
                };
            };
            Tracer.out(("DataManager > position_decor: id " + userDecor.id));
            request = this.make_request((Constants.SERVER_SERVICES + "position_decor.php"));
            (request.data.user_decor_id = userDecor.id);
            (request.data.floor = userDecor.floor);
            (request.data.scale = userDecor.scale);
            (request.data.x_pos = userDecor.x_pos);
            (request.data.y_pos = userDecor.y_pos);
            (request.data.z_pos = userDecor.z_pos);
            loader = this.make_loader();
            loader.addEventListener(Event.COMPLETE, data_loaded);
            loader.load(request);
        }
        public function remove_decor(userDecor:UserDecor):void{
            var request:URLRequest;
            var loader:URLLoader;
            var data_loaded:Function;
            data_loaded = function (_arg1:Event):void{
                var _local2:Object;
                Tracer.out(("DataManager > remove_decor: received " + _arg1.target.data));
                _local2 = Json.decode(_arg1.target.data);
                if (_local2.status == 0)
                {
                    Tracer.out("DataManager > remove_decor : ok");
                    MyBoutique.getInstance().decor_removed(userDecor);
                } else
                {
                    Tracer.out(("DataManager > remove_decor : KO : " + _local2.message));
                    if (_local2.status == Errors.E_NO_FB_SESSION)
                    {
                        Pop_Up.getInstance().alert("Oops!  Facebook Session has expired.  Please reload the page.");
                    };
                };
            };
            Tracer.out(("DataManager > remove_decor: id " + userDecor.id));
            request = this.make_request((Constants.SERVER_SERVICES + "remove_decor.php"));
            (request.data.user_decor_id = userDecor.id);
            loader = this.make_loader();
            loader.addEventListener(Event.COMPLETE, data_loaded);
            loader.load(request);
        }
        public function get_new_decor_id(decor:Decor):void{
            var request:URLRequest;
            var loader:URLLoader;
            var data_loaded:Function;
            data_loaded = function (_arg1:Event):void{
                var _local2:Object;
                Tracer.out(("DataManager > get_new_decor_id: received " + _arg1.target.data));
                _local2 = Json.decode(_arg1.target.data);
                if (_local2.status == 0)
                {
                    Tracer.out("DataManager > get_new_decor_id : ok");
                    UserData.getInstance().complete_decor_purchase(decor, int(_local2.data.userDecorId));
                } else
                {
                    Tracer.out(("DataManager > get_new_decor_id : KO : " + _local2.message));
                    if (_local2.status == Errors.E_NO_FB_SESSION)
                    {
                        Pop_Up.getInstance().alert("Oops!  Facebook Session has expired.  Please reload the page.");
                    };
                };
            };
            Tracer.out("DataManager > get_new_decor_id");
            request = this.make_request((Constants.SERVER_SERVICES + "get_new_decor_id.php"));
            loader = this.make_loader();
            loader.addEventListener(Event.COMPLETE, data_loaded);
            loader.load(request);
        }
		public function update_my_boutique_model(model:UserBoutiqueModel):void {
			//Util.stacktrace();
			
			Tracer.out("DataManager > update_my_boutique_model: floor "+model.floor);
			var request:URLRequest = make_request(Constants.SERVER_SERVICES + "update_my_boutique_model.php");
			
			request.data.model_id = model.id;
			request.data.floor = model.floor;
			request.data.placed = model.placed? 1: 0;
			request.data.scale = model.scale;
			request.data.x_pos = model.x_pos;
			request.data.y_pos = model.y_pos;
			request.data.z_pos = model.z_pos;
			request.data.items = model.item_ids;
			if (model.pet) {
				if (model.item_ids)
					request.data.items += ","+model.pet.id;
				else 
					request.data.items = model.pet.id;
			}
			
			Tracer.out("data.items = "+request.data.items);
			request.data.styles = model.styles;
			Tracer.out("data.styles = "+request.data.styles);

			var loader:URLLoader = make_loader();
			loader.addEventListener(Event.COMPLETE, data_loaded);
			loader.load(request);
			
			function data_loaded(event:Event):void {
				Tracer.out("DataManager > update_my_boutique_model: received "+event.target.data);
				// process standard JSON reply object
				var json:Object = Json.decode(event.target.data);
				if (json.status == 0) {
					Tracer.out("DataManager > update_my_boutique_model : ok");
					
					if (json.data && json.data.newModelId) {
						model.id = json.data.newModelId;
						Tracer.out("DataManager > update_my_boutique_model : new id is "+model.id);
					}
					
					// update the user boutique's model for that floor
					UserData.getInstance().boutique.update_model(model);
					
					MyBoutique.getInstance().model_updated();
				} else {
					Tracer.out("DataManager > update_my_boutique_model : KO : "+json.message);
					if (json.status == Errors.E_NO_FB_SESSION) {
						// user is not logged in or facebook sesssion has expired
						Pop_Up.getInstance().alert("Oops!  Facebook Session has expired.  Please reload the page.");
					} else if (json.status == Errors.E_INVALID_BOUTIQUE_FLOOR) {
						// user does not own the floor specified
						Pop_Up.getInstance().alert("Oops!  You don't yet own floor "+model.floor+".  Please reload the page.");
					} 
				}
			}
		}
        /*public function update_my_boutique_model(model:UserBoutiqueModel):void{
            var request:URLRequest;
            var loader:URLLoader;
            var data_loaded:Function;
            data_loaded = function (_arg1:Event):void{
                var _local2:Object;
                Tracer.out(("DataManager > update_my_boutique_model: received " + _arg1.target.data));
                _local2 = Json.decode(_arg1.target.data);
                if (_local2.status == 0)
                {
                    Tracer.out("DataManager > update_my_boutique_model : ok");
                    if (((_local2.data) && (_local2.data.newModelId)))
                    {
                        (model.id = _local2.data.newModelId);
                        Tracer.out(("DataManager > update_my_boutique_model : new id is " + model.id));
                    };
                    UserData.getInstance().boutique.update_model(model);
                    MyBoutique.getInstance().model_updated();
                } else
                {
                    Tracer.out(("DataManager > update_my_boutique_model : KO : " + _local2.message));
                    if (_local2.status == Errors.E_NO_FB_SESSION)
                    {
                        Pop_Up.getInstance().alert("Oops!  Facebook Session has expired.  Please reload the page.");
                    } else
                    {
                        if (_local2.status == Errors.E_INVALID_BOUTIQUE_FLOOR)
                        {
                            Pop_Up.getInstance().alert((("Oops!  You don't yet own floor " + model.floor) + ".  Please reload the page."));
                        };
                    };
                };
            };
            Tracer.out(("DataManager > update_my_boutique_model: floor " + model.floor));
            request = this.make_request((Constants.SERVER_SERVICES + "update_my_boutique_model.php"));
            (request.data.model_id = model.id);
            (request.data.floor = model.floor);
            (request.data.placed = ((model.placed) ? 1 : 0));
            (request.data.scale = model.scale);
            (request.data.x_pos = model.x_pos);
            (request.data.y_pos = model.y_pos);
            (request.data.z_pos = model.z_pos);
            (request.data.items = model.item_ids);
            if (model.pet)
            {
                if (model.item_ids)
                {
                    (request.data.items = (request.data.items + ("," + model.pet.id)));
                } else
                {
                    (request.data.items = model.pet.id);
                };
            };
            Tracer.out(("data.items = " + request.data.items));
            (request.data.styles = model.styles);
            Tracer.out(("data.styles = " + request.data.styles));
            loader = this.make_loader();
            loader.addEventListener(Event.COMPLETE, data_loaded);
            loader.load(request);
        }*/
		public function launch_boutique(png:ByteArray, entry_floor:int, success:Function):void {
			trace("me  0");
			Tracer.out("DataManager > launch_boutique : entry_floor is "+entry_floor);
			var header:URLRequestHeader = new URLRequestHeader("Content-type","application/octet-stream");
			trace("url  "+Constants.SERVER_SERVICES + "launch_my_boutique.php?client_key=" + client_key + "&session="+fb_session + "&entry_floor=" + entry_floor);
			var request:URLRequest = new URLRequest("http://viroxotystudios.com/testing/protected/services_ipad/launch_my_boutique.php?client_key=" + client_key + "&session="+fb_session + "&entry_floor=" + entry_floor+"&user_id="+user_id);
			//var request:URLRequest = new URLRequest("http://viroxoty.com/testing/protected/services_ipad/launch_my_boutique.php?client_key=" + client_key + "&session="+fb_session + "&entry_floor=" + entry_floor+"&user_id="+user_id);
			request.requestHeaders.push(header);
			request.method = URLRequestMethod.POST;
			
			request.data = png;
			
			trace("me  1");
			var loader:URLLoader = make_loader();
			loader.addEventListener(Event.COMPLETE, data_loaded);
			loader.load(request);
			trace("me  2");
			function data_loaded(event:Event):void {
				Tracer.out("DataManager > launch_my_boutique: received "+event.target.data);
				// process standard JSON reply object
				trace("me  3   "+ event.target.data);
				var json:Object = com.adobe.serialization.json.JSON.decode(event.target.data);
				if (json.status == 0) {
					trace("me  4");
					Tracer.out("DataManager > launch_my_boutique : ok");
					// if first_time user that has not yet seen tutorial end, then show tutorial end if they close
					if (UserData.getInstance().show_tutorial_end && Tracker.first_time_tutorial_end == false) {
						UserData.getInstance().show_tutorial_end = false;
						PopupIntro.getInstance().display_popup(PopupIntro.TUTORIAL_END);
					}
					trace("me  5");
					// show the invite friends popup over the game
					//FacebookConnector.invite_boutique_launch();
					// update start time so fresh pngs will be loaded
					Constants.update_start_time();
					//
					trace("me  6");
					success();
				} else {
					trace("me  7");
					Tracer.out("DataManager > launch_my_boutique : KO : "+json.message);
					if (json.status == Errors.E_NO_FB_SESSION) {
						// user is not logged in or facebook sesssion has expired
						Pop_Up.getInstance().alert("Oops!  Facebook Session has expired.  Please reload the page.");
					} else if (json.status == Errors.E_LAUNCH_BOUTIQUE) {
						// The user does not have a boutique
						Pop_Up.getInstance().alert("DEV: You've already launched your boutique - to be fixed");
					}
					else{
						Pop_Up.getInstance().alert("Failed");
					}
					trace("me  6");
				}
			}
		}
        /*public function launch_boutique(png:ByteArray, entry_floor:int, success:Function):void{
            var header:URLRequestHeader;
            var request:URLRequest;
            var loader:URLLoader;
            var data_loaded:Function;
            data_loaded = function (_arg1:Event):void{
                var _local2:Object;
                Tracer.out(("DataManager > launch_my_boutique: received " + _arg1.target.data));
                _local2 = Json.decode(_arg1.target.data);
                if (_local2.status == 0)
                {
                    Tracer.out("DataManager > launch_my_boutique : ok");
                    if (((UserData.getInstance().show_tutorial_end) && ((Tracker.first_time_tutorial_end == false))))
                    {
                        (UserData.getInstance().show_tutorial_end = false);
                        PopupIntro.getInstance().display_popup(PopupIntro.TUTORIAL_END);
                    };
                    FacebookConnector.invite_boutique_launch();
                    Constants.update_start_time();
                    success();
                } else
                {
                    Tracer.out(("DataManager > launch_my_boutique : KO : " + _local2.message));
                    if (_local2.status == Errors.E_NO_FB_SESSION)
                    {
                        Pop_Up.getInstance().alert("Oops!  Facebook Session has expired.  Please reload the page.");
                    } else
                    {
                        if (_local2.status == Errors.E_LAUNCH_BOUTIQUE)
                        {
                            Pop_Up.getInstance().alert("DEV: You've already launched your boutique - to be fixed");
                        };
                    };
                };
            };
            Tracer.out(("DataManager > launch_boutique : entry_floor is " + entry_floor));
            header = new URLRequestHeader("Content-type", "application/octet-stream");
            request = new URLRequest(((((((Constants.SERVER_SERVICES + "launch_my_boutique.php?client_key=") + this.client_key) + "&session=") + this.fb_session) + "&entry_floor=") + entry_floor));
            request.requestHeaders.push(header);
            (request.method = URLRequestMethod.POST);
            (request.data = png);
            loader = this.make_loader();
            loader.addEventListener(Event.COMPLETE, data_loaded);
            loader.load(request);
        }*/
        public function set_boutique_active(success:Function, fail:Function){
            var request:URLRequest;
            var loader:URLLoader;
            var data_loaded:Function;
            data_loaded = function (_arg1:Event):void{
                var _local2:Object;
                Tracer.out(("DataManager > set_boutique_active: received " + _arg1.target.data));
                _local2 = Json.decode(_arg1.target.data);
                if (_local2.status == 0)
                {
                    success();
                    (UserData.getInstance().boutique.active = true);
                    (UserData.getInstance().has_active_boutique = true);
                    FacebookConnector.invite_boutique_launch();
                    if (Main.getInstance().current_section == Constants.SECTION_MY_BOUTIQUE)
                    {
                        MyBoutique.getInstance().directory_controller.update_a_list();
                    };
                } else
                {
                    Tracer.out(("DataManager > set_boutique_active : KO : " + _local2.message));
                    if (_local2.status == Errors.E_NO_FB_SESSION)
                    {
                        Pop_Up.getInstance().alert("Oops!  Facebook Session has expired.  Please reload the page.");
                    };
                    fail();
                };
            };
            Tracer.out("DataManager > set_boutique_active");
            request = this.make_request((Constants.SERVER_SERVICES + "set_boutique_active.php"));
            loader = this.make_loader();
            loader.addEventListener(Event.COMPLETE, data_loaded);
            loader.load(request);
        }
        public function update_my_boutique_thumb(png:ByteArray):void{
            var header:URLRequestHeader;
            var request:URLRequest;
            var loader:URLLoader;
            var data_loaded:Function;
            data_loaded = function (_arg1:Event):void{
                var _local2:Object;
                Tracer.out(("DataManager > update_my_boutique_thumb: received " + _arg1.target.data));
                _local2 = Json.decode(_arg1.target.data);
                if (_local2.status == 0)
                {
                    Tracer.out("DataManager > update_my_boutique_thumb : ok");
                    Constants.update_start_time();
                } else
                {
                    Tracer.out(("DataManager > update_my_boutique_thumb : KO : " + _local2.message));
                    if (_local2.status != Errors.E_NO_FB_SESSION)
                    {
                        if (_local2.status == Errors.E_LAUNCH_BOUTIQUE)
                        {
                        };
                    };
                };
            };
            Tracer.out("DataManager > update_my_boutique_thumb");
            header = new URLRequestHeader("Content-type", "application/octet-stream");
            request = new URLRequest((((((Constants.SERVER_SERVICES + "launch_my_boutique.php?client_key=") + this.client_key) + "&session=") + this.fb_session) + "&launch=0"));
            request.requestHeaders.push(header);
            (request.method = URLRequestMethod.POST);
            (request.data = png);
            loader = this.make_loader();
            loader.addEventListener(Event.COMPLETE, data_loaded);
            loader.load(request);
        }
        public function visit_my_boutique_level(uid:String, level:int, success:Function):void{
            var request:URLRequest;
            var loader:URLLoader;
            var data_loaded:Function;
            data_loaded = function (_arg1:Event):void{
                var _local2:Object;
                Tracer.out(("DataManager > visit_my_boutique_level: received " + _arg1.target.data));
                _local2 = Json.decode(_arg1.target.data);
                if (_local2.status == 0)
                {
                    Tracer.out("DataManager > visit_my_boutique_level : ok");
                    success(int(_local2.data.visits));
                } else
                {
                    Tracer.out(("DataManager > visit_my_boutique_level : KO : " + _local2.message));
                    if (_local2.status == Errors.E_NO_FB_SESSION)
                    {
                        Pop_Up.getInstance().alert("Oops!  Facebook Session has expired.  Please reload the page.");
                    } else
                    {
                        if (_local2.status == Errors.E_NO_SUCH_BOUTIQUE)
                        {
                            Pop_Up.getInstance().alert((("Oops!  Boutique for user " + uid) + " doesn't exist!"));
                        };
                    };
                };
            };
            Tracer.out("DataManager > visit_boutique_level");
            request = this.make_request((Constants.SERVER_SERVICES + "visit_my_boutique_level.php"));
            (request.data.owner_id = uid);
            (request.data.level = level);
            loader = this.make_loader();
            loader.addEventListener(Event.COMPLETE, data_loaded);
            loader.load(request);
        }
        public function get_boutique_earnings(success_callback:Function=null, fail_callback:Function=null):void{
            var request:URLRequest;
            var loader:URLLoader;
            var data_loaded:Function;
            data_loaded = function (_arg1:Event):void{
                var _local2:Object;
                Tracer.out(("DataManager > get_boutique_earnings: received " + _arg1.target.data));
                _local2 = Json.decode(_arg1.target.data);
                if (_local2.status == 0)
                {
                    Tracer.out("DataManager > get_boutique_earnings : ok");
                    (UserData.getInstance().pending_fcash_reward = _local2.data.boutiqueEarnings);
                    check_user_balances();
                    MessageCenter.getInstance().updateFCash(_local2.data.boutiqueEarnings);
                    if (success_callback != null)
                    {
                        success_callback();
                    };
                } else
                {
                    Tracer.out(("DataManager > get_boutique_earnings : KO : " + _local2.message));
                    if (_local2.status == Errors.E_NO_FB_SESSION)
                    {
                        Pop_Up.getInstance().alert("Oops!  Facebook Session has expired.  Please reload the page.");
                    } else
                    {
                        if (_local2.status == Errors.E_NO_SUCH_BOUTIQUE)
                        {
                            Pop_Up.getInstance().alert((("Oops!  Boutique for user " + user_id) + " doesn't exist!"));
                        };
                    };
                    if (fail_callback != null)
                    {
                        fail_callback();
                    };
                };
            };
            Tracer.out("DataManager > get_boutique_earnings");
            request = this.make_request((Constants.SERVER_SERVICES + "get_boutique_earnings.php"));
            loader = this.make_loader();
            loader.addEventListener(Event.COMPLETE, data_loaded);
            loader.load(request);
        }
        public function show_like_button():void{
            var request:URLRequest;
            var loader:URLLoader;
            var data_loaded:Function;
            data_loaded = function (_arg1:Event):void{
                var _local2:Object;
                Tracer.out(("DataManager > show_like_button: received " + _arg1.target.data));
                _local2 = Json.decode(_arg1.target.data);
                if (_local2.status == 0)
                {
                    Tracer.out("DataManager > show_like_button : ok");
                    (UserData.getInstance().pending_fcash_reward = _local2.data.reward);
                    check_user_balances();
                    if ((((Main.getInstance().current_section == Constants.SECTION_MY_BOUTIQUE)) || ((Main.getInstance().current_section == Constants.SECTION_BOUTIQUE_VISIT))))
                    {
                        Main.getInstance().screen_controller.hide_heart_btn();
                    };
                    (UserData.getInstance().show_like_button = false);
                } else
                {
                    Tracer.out(("DataManager > show_like_button : KO : " + _local2.message));
                    if (_local2.status == Errors.E_NO_FB_SESSION)
                    {
                        Pop_Up.getInstance().alert("Oops!  Facebook Session has expired.  Please reload the page.");
                    } else
                    {
                        if (_local2.status == Errors.E_ALREADY_REWARDED)
                        {
                            Pop_Up.getInstance().alert("Oops!  You already received this reward");
                        };
                    };
                };
            };
            Tracer.out("DataManager > show_like_button");
            request = this.make_request((Constants.SERVER_SERVICES + "show_like_button.php"));
            loader = this.make_loader();
            loader.addEventListener(Event.COMPLETE, data_loaded);
            loader.load(request);
        }
        public function save_album(album:Album):void{
            var request:URLRequest;
            var loader:URLLoader;
            var data_loaded:Function;
            data_loaded = function (_arg1:Event):void{
                Tracer.out(("DataManager > save_album: received " + _arg1.target.data));
            };
            Tracer.out("DataManager > save_album");
            request = this.make_request((Constants.SERVER_SERVICES + "save_album.php"));
            (request.data.album_type = album.type);
            (request.data.album_id = album.id);
            loader = this.make_loader();
            loader.addEventListener(Event.COMPLETE, data_loaded);
            loader.load(request);
        }

    }
}//package com.viroxoty.fashionista

