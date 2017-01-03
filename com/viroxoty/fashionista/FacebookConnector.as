// Decompiled by AS3 Sorcerer 1.78
// http://www.as3sorcerer.com/

//com.viroxoty.fashionista.FacebookConnector

package com.viroxoty.fashionista{
    import com.viroxoty.fashionista.data.Friend;
    import flash.display.BitmapData;
    import com.viroxoty.fashionista.data.PurchasableObject;
    import com.viroxoty.fashionista.data.Item;
    import com.viroxoty.fashionista.data.Decor;
    import com.viroxoty.fashionista.data.*;
    import com.viroxoty.fashionista.ui.*;
    import com.viroxoty.fashionista.user_boutique.*;
    import com.adobe.serialization.json.*;
    import com.viroxoty.fashionista.main.*;
    import com.viroxoty.fashionista.util.*;
    import com.facebook.graph.*;
    import flash.utils.ByteArray;
	import mx.graphics.codec.JPEGEncoder;
	import flash.utils.ByteArray;
	import flash.net.URLRequestHeader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLLoader;
	import flash.events.IOErrorEvent;
	import flash.events.Event;
	import com.viroxoty.fashionista.util.PNGEncoder;

    public class FacebookConnector {

        static const PURCHASE_TYPE_FCASH:String = "fcash";
        static const PURCHASE_TYPE_ITEM:String = "item";
        static const PURCHASE_TYPE_DECOR:String = "decor";
        static const PURCHASE_TYPE_FLOOR:String = "floor";
        static const PURCHASE_TYPE_DAILY_DEAL:String = "daily_deal";
        static const PURCHASE_TYPE_CHANGE_TEAMS:String = "change_teams";
        static const PURCHASE_TYPE_PR_AGENT:String = "pr_agent";
        static const PURCHASE_TYPE_LOOK_OF_THE_DAY:String = "lotd";
        static const PURCHASE_TYPE_SECOND_BOUTIQUE_MODEL:String = "model";

        static function api(strMethodName:String,_arg1:Object, _arg2:String="feed", _arg3:Function=null, _arg4:String="me"):void{
            var _local5:String = ((("/" + _arg4) + "/") + _arg2);
            Tracer.out((((("FacebookConnector > POSTing " + JSON.encode(_arg1)) + " to ") + _local5) + " ..."));
            if (_arg3 == null)
            {
                _arg3 = getStatusHandler;
            };
           // Facebook.api(_local5, _arg3, _arg1, "POST");
			//ExternalInterface.call("fashionista.external.testJSFB", _arg1);
			External.CallFacebookAPI(strMethodName,_arg1,_arg2, _arg3, _arg4);
			_arg3();
        }
        static function getStatusHandler(_arg1:Object, _arg2:Object=null):void{
            Tracer.out("Callback: facebook transaction complete");
            if (_arg1)
            {
                Tracer.out(("RESULT:\n" + JSON.encode(_arg1)));
            } else
            {
                Tracer.out(("FAIL:\n" + JSON.encode(_arg2)));
                Pop_Up.getInstance().alert("Oops! Facebook may be limiting your ability to post.  You should be able to post again from this app in 24 hours");
            };
        }
        public static function get_friend_data(friend:Friend):void{
            var got_friend_data:* = undefined;
            got_friend_data = function (_arg1:Object, _arg2:Object=null):void{
                Tracer.out("got_friend_data");
                if (_arg1)
                {
                    Tracer.out(("RESULT:\n" + JSON.encode(_arg1)));
                    friend.update_fb_data(_arg1);
                } else
                {
                    Tracer.out(("FAIL:\n" + JSON.encode(_arg2)));
                };
            };
            var url:String = (("/" + friend.user_id) + "/");
            Facebook.api(url, got_friend_data, {}, "GET");
			//ExternalInterface.call("fashionista.external.testJSFB", _arg1);
        }
        public static function open_profile(_arg1:String){
            Util.open_url(Constants.fb_profile_for_id(_arg1));
        }
        public static function share_level():void{
            var _local1:String = UserData.getInstance().user_name;
            var _local2 = (_local1 + " is a Fashionista in Fashionista FaceOff!");
            var _local3:int = UserData.getInstance().level;
            var _local4:String = ((_local1 + " reached Fashionista Level ") + _local3);
            var _local5 = (_local1 + " has just leveled up in Fashionista FaceOff and is one step closer to becoming the Ultimate Fashionista!");
            var _local6:String = ((((_local3 % 2))==0) ? "level_a.png" : "level_b.png");
            var _local7:String = Util.url_with_http((Constants.SERVER_IMAGES + _local6));
            var _local8:Array = [{
                "name":"Become A Fashionista",
                "link":Constants.FACEBOOK_APP_PAGE
            }];
            var _local9:Object = {
                "message":"",
                "name":_local2,
                "link":Constants.FACEBOOK_APP_PAGE,
                "picture":_local7,
                "caption":_local4,
                "description":_local5,
                "actions":JSON.encode(_local8)
            };
            api("share_level",_local9);
        }
        public static function share_birthday():void{
            var _local1:String = UserData.getInstance().user_name;
            var _local2 = (_local1 + " is a Fashionista in Fashionista FaceOff!");
            var _local3 = (_local1 + " got a birthday gift!");
            var _local4 = (_local1 + " just celebrated a birthday on Fashionista FaceOff with a gift of 250 FashionCash gift and a fabulous surprise in their closet-  time for a shopping spree!");
            var _local5:String = Util.url_with_http((Constants.SERVER_IMAGES + "birthday3.png"));
            var _local6:Array = [{
                "name":"Become A Fashionista",
                "link":Constants.FACEBOOK_APP_PAGE
            }];
            var _local7:Object = {
                "message":"",
                "name":_local2,
                "link":Constants.FACEBOOK_APP_PAGE,
                "picture":_local5,
                "caption":_local3,
                "description":_local4,
                "actions":JSON.encode(_local6)
            };
            api("share_birthday",_local7);
        }
        public static function share_floor(_arg1:int):void{
            var _local2:String = UserData.getInstance().user_name;
            var _local3 = "";
            var _local4 = "Fashionista FaceOff";
            var _local5 = (((_local2 + " just bought BoutiqueLevel ") + _arg1) + " and is on their way to building their Fashion Empire!");
            var _local6:Array = [{
                "name":"Become A Fashionista",
                "link":Constants.FACEBOOK_APP_PAGE
            }];
            var _local7:String = Util.url_with_http(Constants.IMAGE_ADD_FLOOR);
            Tracer.out(("share_floor > image is " + _local7));
            var _local8:Object = {
                "message":_local3,
                "name":_local4,
                "link":Constants.FACEBOOK_APP_PAGE,
                "picture":_local7,
                "caption":" ",
                "description":_local5,
                "actions":JSON.encode(_local6)
            };
            api("share_floor",_local8);
        }
        public static function share_heart(_arg1:String):void{
            var _local2 = "";
            var _local3:String = UserData.getInstance().user_name;
            var _local4 = (_local3 + " loves fashion!");
            var _local5 = (("Do you love fashion as much as " + _local3) + "?  They received this beautiful jeweled heart for being a top fashionista in Fashionista FaceOff!");
            var _local6:Array = [{
                "name":"Become A Fashionista",
                "link":Constants.FACEBOOK_APP_PAGE
            }];
            _arg1 = Util.url_with_http(_arg1);
            var _local7:Object = {
                "message":_local2,
                "name":_local4,
                "link":Constants.FACEBOOK_APP_PAGE,
                "name":_local4,
                "picture":_arg1,
                "caption":" ",
                "description":_local5,
                "actions":JSON.encode(_local6)
            };
            api("share_heart",_local7, "feed");
        }
        public static function share_my_boutique_earnings(_arg1:int):void{
            var _local2:String = UserData.getInstance().user_name;
            var _local3 = (_local2 + "'s Boutique is Open for Business");
            var _local4 = "Fashionista FaceOff";
            var _local5 = (("You can help " + _local2) + " earn more FashionCash by visiting their Boutique today!");
            var _local6:String = UserData.getInstance().my_boutique_url;
            var _local7:Array = [{
                "name":"Visit Boutique",
                "link":Constants.FACEBOOK_APP_PAGE
            }];
            var _local8:Object = {
                "message":"",
                "name":_local3,
                "link":Constants.FACEBOOK_APP_PAGE,
                "picture":_local6,
                "caption":_local4,
                "description":_local5,
                "actions":JSON.encode(_local7)
            };
            api("share_my_boutique_earnings",_local8);
        }
        public static function share_paris():void{
            var _local1:String = UserData.getInstance().user_name;
            var _local2 = (_local1 + " is a Fashionista in Fashionista FaceOff!");
            var _local3 = (_local1 + " accessed a new city");
            var _local4 = (_local1 + " just arrived in Fantasy Paris and is one step closer to be becoming the Ultimate Fashionista in Fashionista FaceOff!");
            var _local5:String = Util.url_with_http((Constants.SERVER_IMAGES + "fpfeed.jpg"));
            var _local6:Array = [{
                "name":"Become A Fashionista",
                "link":Constants.FACEBOOK_APP_PAGE
            }];
            var _local7:Object = {
                "message":"",
                "name":_local2,
                "link":Constants.FACEBOOK_APP_PAGE,
                "picture":_local5,
                "caption":_local3,
                "description":_local4,
                "actions":JSON.encode(_local6)
            };
            api("share_paris",_local7);
        }
        public static function share_stats():void{
            var _local1:String = UserData.getInstance().user_name;
            var _local2 = (_local1 + " needs your votes!");
            var _local3 = "They're leading in today's Fashionista FaceOff competition, and need your help to win!";
            var _local4:String = Util.url_with_http((Constants.SERVER_IMAGES + "vote.png"));
            var _local5:Array = [{
                "name":"Become A Fashionista",
                "link":Constants.FACEBOOK_APP_PAGE
            }];
            var _local6:Object = {
                "message":"",
                "name":_local2,
                "link":Constants.FACEBOOK_APP_PAGE,
                "picture":_local4,
                "caption":" ",
                "description":_local3,
                "actions":JSON.encode(_local5)
            };
            api("share_stats",_local6);
        }
        public static function share_team(_arg1:String, _arg2:String):void{
            var _local3:String = UserData.getInstance().user_name;
            var _local4 = "";
            _arg1 = ((_local3 + " has just joined ") + _arg1);
            var _local5 = "Help their FashionTeam win by voting for their team's looks in Fashionista FaceOff!";
            var _local6:Array = [{
                "name":"Become A Fashionista",
                "link":Constants.FACEBOOK_APP_PAGE
            }];
            _arg2 = Util.url_with_http(_arg2);
            var _local7:Object = {
                "message":_local4,
                "name":_arg1,
                "link":Constants.FACEBOOK_APP_PAGE,
                "picture":_arg2,
                "caption":" ",
                "description":_local5,
                "actions":JSON.encode(_local6)
            };
            api("share_team",_local7);
        }
        static function post_photo(album_type:String, data:Object, success:Function=null){
			
			var header:URLRequestHeader = new URLRequestHeader("Content-type","application/octet-stream");
			var png_url:URLRequest = new URLRequest("http://viroxoty.com/pnguploader.php");
			png_url.requestHeaders.push(header);
			png_url.method = URLRequestMethod.POST;
			var bytes:ByteArray = com.viroxoty.fashionista.util.PNGEncoder.encode(data.image);
			png_url.data = bytes;
			
			var png_loader:URLLoader = new URLLoader();
			png_loader.addEventListener(Event.COMPLETE, image_loader_complete);
			png_loader.addEventListener(IOErrorEvent.IO_ERROR, image_loader_error);
			png_loader.load(png_url);
			MainViewController.getInstance().show_modal_html_popup();
			
			function image_loader_complete(evt:Event):void {
				Tracer.out(evt.target.data);	
				data.url="http://viroxoty.com/nav/"+evt.target.data;
				MainViewController.getInstance().hide_modal_html_popup();
				api("post_photo",data, "photos");				
			}

			function image_loader_error(event:Event):void {
				Tracer.out("Error "+event.target.data);
			}
		
			
			/*
			var photo_handler:* = undefined;
            var album_handler:* = undefined;
			
			
            var upload_photo:* = function (_arg1:String){
                Tracer.out(("upload_photo to " + _arg1));
                api("post_photo",data, "photos", photo_handler, _arg1);
            };
            photo_handler = function (_arg1:Object, _arg2:Object=null){
                if (_arg1)
                {
                    Tracer.out(("photo_handler > result is : " + JSON.encode(_arg1)));
                    if (success != null)
                    {
                        success(_arg1);
                    };
                } else
                {
                    Tracer.out(("album_handler > FAIL: " + JSON.encode(_arg2)));
                    create_album();
                };
            };
            var create_album:* = function (){
                Tracer.out("creating album");
                var _local1:Object = {
                    "name":Album.nameForType(album_type),
                    "message":Album.descriptionForType(album_type)
                };
                api("create_album",_local1, "albums", album_handler);
            };
            album_handler = function (result:Object, fail:Object=null):void{
                var album_id:String;
                if (result)
                {
                    var do_photo_upload:* = function (){
                        upload_photo(album_id);
                    };
                    Tracer.out(("album_handler > result is : " + JSON.encode(result)));
                    album_id = String(result.id);
                    UserData.getInstance().save_album(album_type, album_id);
                    Pop_Up.getInstance().display_popup(Pop_Up.ALERT, (("Your " + Album.nameForType(album_type)) + " album was created."), do_photo_upload);
                } else
                {
                    Tracer.out(("album_handler > FAIL: " + JSON.encode(fail)));
                    Pop_Up.getInstance().alert("Oops! Facebook may be limiting your ability to post.  You should be able to post again from this app in 24 hours");
                    return;
                };
            };
            var album_id:String = UserData.getInstance().get_album_id_for_type(album_type);
            if (album_id)
            {
                (upload_photo(album_id));
            } else
            {
                (create_album());
            };*/
        }
        public static function post_look_photo(bitmap:BitmapData, caption:String, is_user_look:Boolean=false):void{
            var success:* = undefined;
            success = function (_arg1:Object){
                if (is_user_look)
                {
                    SnapshotController.getInstance().photo_posted(String(_arg1.id));
                } else
                {
                    Notification.getInstance().small_notice((("Your photo was saved to your " + Album.nameForType(Album.TYPE_LOOKS)) + " Album"));
                };
            };
            Tracer.out("FacebookConnector > post_look_photo");
            var user_name:String = UserData.getInstance().user_name;
            var d:Date = new Date();
            var ds:String = String(d.time);
            var data:Object = {
                "message":caption,
                "image":bitmap,
                "fileName":("FF_look_" + ds)
            };
            //post_photo(((is_user_look) ? Album.TYPE_MY_LOOKS : Album.TYPE_LOOKS), data, success);
			post_photo(((is_user_look) ? Album.TYPE_MY_LOOKS : Album.TYPE_LOOKS), data);
        }
        public static function post_boutique_photo(bitmap:BitmapData, level:int, caption:String, type:String="boutiques"):void{
            var boutique_photo_status_handler:* = undefined;
            boutique_photo_status_handler = function (_arg1:Object, _arg2:Object=null):void{
                Tracer.out("Callback: facebook boutique photo post complete");
                if (_arg1)
                {
                    Tracer.out(("RESULT:\n" + JSON.encode(_arg1)));
                    Notification.getInstance().small_notice((("Your photo was saved to your " + Album.nameForType(type)) + " Album!"));
                } else
                {
                    Tracer.out(("FAIL:\n" + JSON.encode(_arg2)));
                    Notification.getInstance().small_notice("Facebook Server Error when trying to save to your Fashionista FaceOff Album!");
                };
            };
            Tracer.out("FacebookConnector > post_boutique_photo");
            var user_name:String = UserData.getInstance().user_name;
            var d:Date = new Date();
            var ds:String = String(d.time);
            var data:Object = {
                "message":caption,
                "image":bitmap,
                "fileName":((("FF_boutique_level_" + level) + "_") + ds)
            };
            //post_photo(type, data, boutique_photo_status_handler);
			post_photo(type, data);
        }
        public static function thank(_arg1:String, _arg2:String, _arg3:String, _arg4:String, _arg5:String):void{
            var _local6:String = UserData.getInstance().user_name;
            var _local7 = "";
            var _local8 = "Thank you for the fabulous gift!";
            var _local9 = (('"' + _arg4) + '"');
            var _local10:Array = [{
                "name":"Become A Fashionista",
                "link":Constants.FACEBOOK_APP_PAGE
            }];
            Tracer.out(("PostGenerator > thank : picture is " + _arg5));
            var _local11:Object = {
                "message":_local7,
                "name":_local8,
                "link":Constants.FACEBOOK_APP_PAGE,
                "url":Util.url_with_http(_arg5),
                "caption":_arg3,
                "description":_local9,
                "actions":JSON.encode(_local10)
            };
            api("thank",_local11, "feed", null, _arg2);
        }
        public static function invite_friends(_arg1:String=null):void{
            var _local2:String = UserData.getInstance().user_name;
            var _local3:Object = {
                "message":"Let's play Fashionista FaceOff! Get fabulous clothes, walk the runway and become Fashionista of the Year!",
                "title":"Invite Your Friends to Play Fashionista FaceOff!",
                "filters":["app_non_users"]
            };
            if (_arg1)
            {
                _local3.title = _arg1;
            };
            appRequest("invite_friends",_local3);
        }
        public static function invite_friend(_arg1:Friend, _arg2:String=null, _arg3:String=null):void{
			Tracer.out("invite_friend  Facebook UI");
            var _local4:String = UserData.getInstance().user_name;
            var _local5:Object = {
                "message":"Let's play Fashionista FaceOff! Get fabulous clothes, walk the runway and become Fashionista of the Year!",
                "title":"Get 50 FashionCash for each new friend who plays",
                "to":_arg1.user_id
            };
            if (_arg3)
            {
                _local5.title = _arg3;
            };
            if (_arg2)
            {
                _local5.message = _arg2;
            };
            appRequest("invite_friend",_local5);
        }
        public static function invite_team(_arg1:int, _arg2:String):void{
            var _local3:String = UserData.getInstance().user_name;
            var _local4:Object = {
                "message":(("Come play Fashionista FaceOff with me, where you can join me on " + _arg2) + " FashionTeam! Get fabulous clothes, walk the runway and help our team win!"),
                "title":(("Invite Your Friends to join " + _arg2) + "!"),
                "data":("action=join_team&id=" + _arg1)
            };
            appRequest("invite_team",_local4);
        }
        public static function invite_a_list():void{
            var _local1:String = UserData.getInstance().user_name;
            var _local2:Object = {
                "message":(((("Join " + _local1) + "'s A-List! By joining ") + _local1) + "'s A-List of fun, fashionable friends, you'll be able to enjoy fun shopping sprees and fashion shows in Fashionista FaceOff!"),
                "title":"Invite Friends To Be On Your A-List!",
                "filters":["app_non_users"]
            };
            appRequest("invite_a_list",_local2);
        }
        public static function openGiftFriendSelector(gift:PurchasableObject, type:String):void{
            External.GIFT_ID= gift.id;
			External.GIFT_TYPE=type;
			var giftAppRequestHandler:* = undefined;
            giftAppRequestHandler = function (_arg1:Object, _arg2:Object=null):void{
                Tracer.out("appRequestHandler: app request complete");
                MainViewController.getInstance().hide_modal_html_popup();
                if (_arg1)
                {
                    Tracer.out(("RESULT:\n" + JSON.encode(_arg1)));
                } else
                {
                    Tracer.out(("FAIL:\n" + JSON.encode(_arg2)));
                    return;
                };
                var _local3:String = _arg1.request;
                var _local4:Array = _arg1.to;
                Tracer.out(("request id is " + _local3), ("user_ids are " + _local4));
                if (type == Constants.REQUEST_FREE_ITEM)
                {
                    UserData.getInstance().daily_free_give = true;
                    DataManager.getInstance().track_daily_free_gift();
                };
            };
            var userName:String = UserData.getInstance().user_name;
            MainViewController.getInstance().show_modal_html_popup();
            var data:Object = {"title":"Select up to 50 friends to receive this gift!"};
            if (type == Constants.REQUEST_PERFUME_GIFT)
            {
                data.message = (((("You have a fabulous bottle of " + gift.name) + " from ") + userName) + "!");
            } else
            {
                data.message = (((((userName + " has sent you this fabulous ") + (((gift is Item)) ? "item" : "decor")) + ": ") + gift.name) + "!");
            };
            data.data = ((("action=" + type) + "&id=") + gift.id);
			appRequest("giftfriendselector",data, giftAppRequestHandler);
        }
        public static function invite_boutique_launch():void{
            var _local1:String = UserData.getInstance().user_name;
            var _local2:Object = {
                "message":(_local1 + " invites you to the grand opening of their boutique in Fashionista FaceOff"),
                "title":"Invite up to 50 of your friends to your boutique!"
            };
            Tracer.out(" invite_boutique_launch > calling Facebook.ui...");
            appRequest("invite_boutique_launch",_local2);
        }
        public static function invite_boutique_friends():void{
            var _local1:String = UserData.getInstance().user_name;
            var _local2:Object = {
                "message":(_local1 + " invites you to create a boutique in Fashionista FaceOff"),
                "title":"Ask your friends to create their own boutique!"
            };
			appRequest("invite_boutique_friends",_local2);
        }
        static function appRequest(strMethodName:String,_arg1:Object, _arg2:Function=null):void{
            if (_arg2 == null)
            {
                _arg2 = appRequestHandler;
            };
            MainViewController.getInstance().show_modal_html_popup();
            Tracer.out(" calling Facebook.ui...");
            //Facebook.ui("apprequests", _arg1, _arg2, "iframe");
			//ExternalInterface.call("fashionista.external.testJSFB", _arg1);
			External.CallFacebookUI(strMethodName,_arg1);
        }
        static function appRequestHandler(_arg1:Object, _arg2:Object=null):void{
            Tracer.out("appRequestHandler: app request complete");
            MainViewController.getInstance().hide_modal_html_popup();
            if (_arg1)
            {
                Tracer.out(("RESULT:\n" + JSON.encode(_arg1)));
            } else
            {
                Tracer.out(("FAIL:\n" + JSON.encode(_arg2)));
            };
        }
        public static function buy_fashion_cash(credits:int, success_callback:Function):void{
            var cashPayHandler:* = undefined;
            cashPayHandler = function (_arg1:Object, _arg2:Object=null):void{
                Tracer.out("cashPayHandler: facebook transaction complete");
                var _local3:Boolean;
                if (_arg1)
                {
                    Tracer.out(("\n\nRESULT:\n" + JSON.encode(_arg1)));
                    if (_arg1.error_code == null)
                    {
                        _local3 = true;
                    };
                } else
                {
                    Tracer.out(("\n\nFAIL:\n" + JSON.encode(_arg2)));
                };
                if (_local3)
                {
                    DataManager.getInstance().check_user_balances();
                    if (success_callback != null)
                    {
                        success_callback();
                    };
                } else
                {
                    Tracer.out("Fail: did not buy FCash");
                };
            };
            var order_info:String = ((("type=" + PURCHASE_TYPE_FCASH) + "&credits=") + credits);
            call_fb_pay_ui(order_info, cashPayHandler);
        }
        public static function buy_item(item:Item, success_callback:Function, fail_callback:Function):void{
            var payHandler:* = undefined;
            var reseller_id:String;
            payHandler = function (_arg1:Object, _arg2:Object=null):void{
                Tracer.out("payHandler: facebook transaction complete");
                var _local3:Boolean;
                if (_arg1)
                {
                    Tracer.out(("\n\nRESULT:\n" + JSON.encode(_arg1)));
                    if (_arg1.error_code == null)
                    {
                        _local3 = true;
                    };
                } else
                {
                    Tracer.out(("\n\nFAIL:\n" + JSON.encode(_arg2)));
                };
                if (_local3)
                {
                    Tracer.out("Success: bought item");
                    if (success_callback != null)
                    {
                        success_callback();
                    };
                } else
                {
                    Tracer.out("Fail: did not buy item");
                    if (fail_callback() != null)
                    {
                        fail_callback();
                    };
                };
            };
            var order_info:String = ((("type=" + PURCHASE_TYPE_ITEM) + "&item_id=") + item.id);
            if (Main.getInstance().current_section == Constants.SECTION_BOUTIQUE_VISIT)
            {
                reseller_id = BoutiqueVisit.getInstance().user_id;
                order_info = (order_info + ("&reseller_id=" + reseller_id));
            };
            call_fb_pay_ui(order_info, payHandler);
        }
        public static function gift_item(item:Item, friend_id:String, success_callback:Function, fail_callback:Function):void{
            var payHandler:* = undefined;
            payHandler = function (_arg1:Object, _arg2:Object=null):void{
                Tracer.out("payHandler: facebook transaction complete");
                var _local3:Boolean;
                if (_arg1)
                {
                    Tracer.out(("\n\nRESULT:\n" + JSON.encode(_arg1)));
                    if (_arg1.error_code == null)
                    {
                        _local3 = true;
                    };
                } else
                {
                    Tracer.out(("\n\nFAIL:\n" + JSON.encode(_arg2)));
                };
                if (_local3)
                {
                    Tracer.out("Success: gifted item");
                    DataManager.getInstance().check_user_balances();
                    if (success_callback != null)
                    {
                        success_callback();
                    };
                } else
                {
                    Tracer.out("Fail: did not buy item");
                    if (fail_callback != null)
                    {
                        fail_callback();
                    };
                };
            };
            var order_info:String = (((((("type=" + PURCHASE_TYPE_ITEM) + "&item_id=") + item.id) + "&friend_id=") + friend_id) + "&gift=1");
            call_fb_pay_ui(order_info, payHandler);
        }
        public static function buy_decor(decor:Decor, success_callback:Function, fail_callback:Function):void{
            var payHandler:* = undefined;
            payHandler = function (_arg1:Object, _arg2:Object=null):void{
                Tracer.out("payHandler: facebook transaction complete");
                var _local3:Boolean;
                if (_arg1)
                {
                    Tracer.out(("\n\nRESULT:\n" + JSON.encode(_arg1)));
                    if (_arg1.error_code == null)
                    {
                        _local3 = true;
                    };
                } else
                {
                    Tracer.out(("\n\nFAIL:\n" + JSON.encode(_arg2)));
                };
                if (_local3)
                {
                    Tracer.out("Success: bought decor");
                    DataManager.getInstance().check_user_balances();
                    DataManager.getInstance().get_new_decor_id(decor);
                    if (success_callback != null)
                    {
                        success_callback();
                    };
                } else
                {
                    Tracer.out("Fail: did not buy item");
                    if (fail_callback() != null)
                    {
                        fail_callback();
                    };
                };
            };
            var order_info:String = ((("type=" + PURCHASE_TYPE_DECOR) + "&decor_id=") + decor.id);
            call_fb_pay_ui(order_info, payHandler);
        }
        public static function gift_decor(decor:Decor, friend_id:String, success_callback:Function, fail_callback:Function):void{
            var payHandler:* = undefined;
            payHandler = function (_arg1:Object, _arg2:Object=null):void{
                Tracer.out("payHandler: facebook transaction complete");
                var _local3:Boolean;
                if (_arg1)
                {
                    Tracer.out(("\n\nRESULT:\n" + JSON.encode(_arg1)));
                    if (_arg1.error_code == null)
                    {
                        _local3 = true;
                    };
                } else
                {
                    Tracer.out(("\n\nFAIL:\n" + JSON.encode(_arg2)));
                };
                if (_local3)
                {
                    Tracer.out("Success: gifted decor");
                    DataManager.getInstance().check_user_balances();
                    if (success_callback != null)
                    {
                        success_callback();
                    };
                } else
                {
                    Tracer.out("Fail: did not buy item");
                    if (fail_callback != null)
                    {
                        fail_callback();
                    };
                };
            };
            var order_info:String = (((((("type=" + PURCHASE_TYPE_DECOR) + "&decor_id=") + decor.id) + "&friend_id=") + friend_id) + "&gift=1");
            call_fb_pay_ui(order_info, payHandler);
        }
        public static function buy_floor(floor:int):void{
            var payHandler:* = undefined;
            payHandler = function (_arg1:Object, _arg2:Object=null):void{
                Tracer.out("payHandler: facebook transaction complete");
                var _local3:Boolean;
                if (_arg1)
                {
                    Tracer.out(("\n\nRESULT:\n" + JSON.encode(_arg1)));
                    if (_arg1.error_code == null)
                    {
                        _local3 = true;
                    };
                } else
                {
                    Tracer.out(("\n\nFAIL:\n" + JSON.encode(_arg2)));
                };
                if (_local3)
                {
                    Tracer.out("Success: bought new boutique level");
                    UserData.getInstance().do_boutique_floor_purchase();
                    DataManager.getInstance().check_user_balances();
                    Pop_Up.getInstance().display_popup(Pop_Up.ADD_FLOOR_CONFIRM);
                } else
                {
                    Tracer.out("Fail: did not buy");
                };
            };
            var order_info:String = ((("type=" + PURCHASE_TYPE_FLOOR) + "&floor=") + floor);
            call_fb_pay_ui(order_info, payHandler);
        }
        public static function buy_daily_deal_item(item_id:int, success_callback:Function):void{
            var dailyDealHandler:* = undefined;
            dailyDealHandler = function (_arg1:Object, _arg2:Object=null):void{
                Tracer.out("payHandler: facebook transaction complete");
                if (_arg1)
                {
                    if (_arg1.error_code)
                    {
                        Tracer.out(("\n\nFAIL:\n" + JSON.encode(_arg1)));
                    } else
                    {
                        Tracer.out(("\n\nRESULT:\n" + JSON.encode(_arg1)));
                        DataManager.getInstance().add_daily_deal_item();
                        success_callback();
                    };
                } else
                {
                    Tracer.out(("\n\nFAIL:\n" + JSON.encode(_arg2)));
                };
            };
            var order_info:String = ((("type=" + PURCHASE_TYPE_DAILY_DEAL) + "&item_id=") + item_id);
            call_fb_pay_ui(order_info, dailyDealHandler);
        }
        public static function buy_team_change(id:int, success_callback:Function):void{
            var teamPayHandler:* = undefined;
            teamPayHandler = function (_arg1:Object, _arg2:Object=null):void{
                Tracer.out("teamPayHandler: facebook transaction complete");
                if (_arg1)
                {
                    if (_arg1.error_code)
                    {
                        Tracer.out(("\n\nFAIL:\n" + JSON.encode(_arg1)));
                    } else
                    {
                        Tracer.out(("\n\nRESULT:\n" + JSON.encode(_arg1)));
                        UserData.getInstance().update_team(DataManager.getInstance().get_team_by_id(id));
                        success_callback();
                    };
                } else
                {
                    Tracer.out(("\n\nFAIL:\n" + JSON.encode(_arg2)));
                };
            };
            var order_info:String = ((("type=" + PURCHASE_TYPE_CHANGE_TEAMS) + "&team_id=") + id);
            call_fb_pay_ui(order_info, teamPayHandler);
        }
        public static function hire_pr_agent():void{
            var hire_pr_agent_handler:* = undefined;
            hire_pr_agent_handler = function (_arg1:Object, _arg2:Object=null):void{
                Tracer.out("hire_pr_agent_handler: facebook transaction complete");
                if (_arg1)
                {
                    if (_arg1.error_code)
                    {
                        Tracer.out(("\n\nFAIL:\n" + JSON.encode(_arg1)));
                        Tracer.out("Fail: did not hired PR Agent");
                    } else
                    {
                        Tracer.out(("\n\nRESULT:\n" + JSON.encode(_arg1)));
                        UserData.getInstance().has_pr_agent = true;
                        DressingRoom.getCurrentInstance().hide_agent_btn();
                        Tracker.track("complete", "hire_pr_agent");
                        Pop_Up.getInstance().alert("You've hired a PR Agent!");
                    };
                } else
                {
                    Tracer.out(("\n\nFAIL:\n" + JSON.encode(_arg2)));
                    Tracer.out("Fail: did not hired PR Agent");
                };
            };
            var order_info:String = ("type=" + PURCHASE_TYPE_PR_AGENT);
            call_fb_pay_ui(order_info, hire_pr_agent_handler);
        }
        public static function buy_look_of_the_day(cost:int, fcash:int, item_ids:String):void{
            var lotd_handler:* = undefined;
            lotd_handler = function (_arg1:Object, _arg2:Object=null):void{
                Tracer.out("lotd_handler: facebook transaction complete");
                if (_arg1)
                {
                    if (_arg1.error_code)
                    {
                        Tracer.out(("\n\nFAIL:\n" + JSON.encode(_arg1)));
                        Tracer.out("Fail: did not buy Look Of The Day");
                    } else
                    {
                        Tracer.out(("\n\nRESULT:\n" + JSON.encode(_arg1)));
                        LookOfTheDayController.getInstance().add_items_to_closet();
                        UserData.getInstance().pending_fcash_reward = fcash;
                        DataManager.getInstance().check_user_balances();
                    };
                } else
                {
                    Tracer.out(("\n\nFAIL:\n" + JSON.encode(_arg2)));
                    Tracer.out("Fail: did not buy Look Of The Day");
                };
            };
            if (Constants.DEBUG)
            {
                cost = 1;
            };
            var order_info:String = ((((((("type=" + PURCHASE_TYPE_LOOK_OF_THE_DAY) + "&cost=") + cost) + "&fcash=") + fcash) + "&item_ids=") + item_ids);
            call_fb_pay_ui(order_info, lotd_handler);
        }
        public static function buy_second_model(floor:int):void{
            var payHandler:* = undefined;
            payHandler = function (_arg1:Object, _arg2:Object=null):void{
                Tracer.out("payHandler: facebook transaction complete");
                var _local3:Boolean;
                if (_arg1)
                {
                    Tracer.out(("\n\nRESULT:\n" + JSON.encode(_arg1)));
                    if (_arg1.error_code == null)
                    {
                        _local3 = true;
                    };
                } else
                {
                    Tracer.out(("\n\nFAIL:\n" + JSON.encode(_arg2)));
                };
                if (_local3)
                {
                    Tracer.out(("Success: bought new model for boutique floor " + floor));
                    MyBoutique.getInstance().add_second_model();
                    DataManager.getInstance().check_user_balances();
                } else
                {
                    Tracer.out("Fail: did not buy");
                };
            };
            var order_info:String = ((("type=" + PURCHASE_TYPE_SECOND_BOUTIQUE_MODEL) + "&floor=") + floor);
            call_fb_pay_ui(order_info, payHandler);
        }
        static function call_fb_pay_ui(_arg1:String, _arg2:Function):void{
            var _local3:Object = {
                "order_info":_arg1,
                "purchase_type":"item",
                "dev_purchase_params":{"oscif":true}
            };
            Tracer.out(("calling FB.ui pay with order_info: " + _local3.order_info));
            FB.ui("pay", _local3, _arg2, "iframe");
        }

    }
}//package com.viroxoty.fashionista

