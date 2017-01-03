// Decompiled by AS3 Sorcerer 1.78
// http://www.as3sorcerer.com/

//com.viroxoty.fashionista.Pop_Up

package com.viroxoty.fashionista{
    import flash.display.Sprite;
    import flash.system.ApplicationDomain;
    import flash.display.MovieClip;
    import flash.net.URLRequest;
    import flash.display.Loader;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.text.TextFormat;
    import flash.text.Font;
    import com.viroxoty.fashionista.data.Item;
    import com.viroxoty.fashionista.asset.AssetDataObject;
    import flash.geom.Rectangle;
    import flash.display.DisplayObject;
    import com.viroxoty.fashionista.data.PurchasableObject;
    import com.viroxoty.fashionista.user_boutique.UserBoutiqueModelViewController;
    import flash.display.DisplayObjectContainer;
    import __AS3__.vec.Vector;
    import com.viroxoty.fashionista.data.Friend;
    import com.viroxoty.fashionista.ui.ImageLoader;
    import com.viroxoty.fashionista.ui.ModelWrapper;
    import com.viroxoty.fashionista.data.UserBoutiqueModel;
    import com.viroxoty.fashionista.data.*;
    import flash.events.*;
    import flash.net.*;
    import com.viroxoty.fashionista.boutique.*;
    import flash.text.*;
    import com.viroxoty.fashionista.ui.*;
    import flash.display.*;
    import com.viroxoty.fashionista.user_boutique.*;
    import com.viroxoty.fashionista.sound.*;
    import com.viroxoty.fashionista.asset.*;
    import caurina.transitions.*;
    import com.viroxoty.fashionista.cities.*;
    import com.viroxoty.fashionista.main.*;
    import com.viroxoty.fashionista.util.*;

    public class Pop_Up extends Sprite {

        public static const LIKE_BTN_HIDDEN:String = "LIKE_BTN_HIDDEN";
        public static const POPUP_OPENED:String = "POPUP_OPENED";
        public static const A_LIST_LIMIT:String = "a_list_limit";
        public static const ADD_FLOOR:String = "add_floor";
        public static const ADD_FLOOR_CONFIRM:String = "add_floor_confirm";
        public static const ALERT:String = "alert";
        public static const ALREADY_OWN:String = "already_own";
        public static const ALREADY_VOTED:String = "already_voted";
        public static const BEST_DRESSED_LIST:String = "best_dressed_list";
        public static const BIRTHDAY_DRESS:String = "birthday_dress";
        public static const BIRTHDAY_POPUP:String = "birthday_popup";
        public static const BOUGHT_CASH:String = "bought_cash";
        public static const BOUTIQUE_DIRECTORY:String = "boutique_directory";
        public static const BUY_DECOR:String = "buy_decor";
        public static const BUY_ITEM:String = "buy_item";
        public static const COMING_SOON:String = "coming_soon";
        public static const CONVERSION:String = "conversion";
        public static const DUPLICATE_LOOK:String = "duplicate_look";
        public static const EMPTY_CLOSET:String = "empty_closet";
        public static const ENTER_LOOK_CONFIRM:String = "enter_look_confirm";
        public static const ENTER_LOOK_CONFIRM_MB:String = "enter_look_confirm_mb";
        public static const FACEOFF_INTRO:String = "faceoff_intro";
        public static const FIRST_FACEOFF_WIN:String = "first_faceoff_win";
        public static const FREE_ITEM_REQUEST_CONFIRM:String = "free_item_request_confirm";
        public static const FREE_ITEM_POPUP:String = "free_item_popup";
        public static const FRIEND_ALREADY_HAS:String = "friend_already_has";
        public static const FRIEND_BUY:String = "friend_buy";
        public static const FRIEND_BUY_CONFIRM:String = "friend_buy_confirm";
        public static const FRIEND_MESSAGE_BUY:String = "friend_message_buy";
        public static const FRIEND_REQUEST:String = "friend_request";
        public static const FRIEND_REQUEST_CONFIRM:String = "friend_request_confirm";
        public static const HIRE_AGENT:String = "hire_agent";
        public static const HOW_TO_PLAY:String = "how_to_play";
        public static const JUDGE_CHARLESTON:String = "judge_charleston";
        public static const JUDGE_JOEL:String = "judge_joel";
        public static const JUDGE_KAREN:String = "judge_karen";
        public static const JUDGE_KEYLEE:String = "judge_keylee";
        public static const LEVEL_3:String = "level_3";
        public static const LEVEL_4:String = "level_4";
        public static const LEVEL_5:String = "level_5";
        public static const LEVEL_6:String = "level_6";
        public static const LEVEL_7:String = "level_7";
        public static const LEVEL_8:String = "level_8";
        public static const LEVEL_9:String = "level_9";
        public static const LEVEL_TOO_LOW:String = "level_too_low";
        public static const LEVEL_TOO_LOW_FIRST_TIME:String = "level_too_low_first_time";
        public static const LEVEL_PARIS:String = "level_paris";
        public static const LEVEL_UP:String = "level_up";
        public static const LIKE_CONTAINER:String = "like_container";
        public static const LIKE_FASHIONISTA:String = "like_fashionista";
        public static const LOOK_OF_THE_DAY:String = "look_of_the_day";
        public static const LOOK_PHOTO_CAPTION:String = "photo_caption_look";
        public static const LOOKS_LIMIT:String = "looks_limit";
        public static const MAKE_ME_A_STAR:String = "make_me_a_star";
        public static const MY_BOUTIQUE_DECORATE:String = "my_boutique_decorate";
        public static const MY_BOUTIQUE_DRESS_UP:String = "my_boutique_dress_up";
        public static const MY_BOUTIQUE_PHOTO_CAPTION:String = "photo_caption_my_boutique";
        public static const MY_BOUTIQUE_WELCOME_BACK:String = "my_boutique_welcome_back";
        public static const NEED_MORE_CASH:String = "need_more_cash";
        public static const NO_A_LIST_LOOKS:String = "no_a_list_looks";
        public static const NO_A_LISTER_LOOKS:String = "no_a_lister_looks";
        public static const NO_LOOKS:String = "no_looks";
        public static const NO_MY_LOOKS:String = "no_my_looks";
        public static const NO_TEAM_LOOKS:String = "no_team_looks";
        public static const PARIS_LEVEL_LOW:String = "paris_insufficient_level";
        public static const PARIS_INTRO_1:String = "paris_intro_1";
        public static const PARIS_INTRO_2:String = "paris_intro_2";
        public static const PARIS_WELCOME:String = "paris_welcome";
        public static const PHOTO_CAPTION_RUNWAY:String = "photo_caption_runway";
        public static const PHOTO_CAPTION_USER_BOUTIQUE:String = "photo_caption_user_boutique";
        public static const PUBLISH_LOOK_CONFIRM:String = "publish_look_confirm";
        public static const RESET_MY_BOUTIQUE_CONFIRM:String = "reset_my_boutique_confirm";
        public static const SELECT_MODEL:String = "select_model";
        public static const THREE_DAY_REWARD:String = "three_day_reward";
        public static const VOTE_LIMIT:String = "vote_limit";
        public static const WEEKLY_CHALLENGE:String = "weekly_challenge";

        private static var _instance:Pop_Up;

        private var popupAppDomain:ApplicationDomain;
        var container:Sprite;
        var level_up_container:Sprite;
        var specials_container:Sprite;
        var pending_popups:Array;
        var pending_item_purchase:Object;
        var pending_boutique:String;
        var pending_flight:Boolean;
        private var popup:MovieClip;

        public function Pop_Up(){
            Tracer.out("New Pop_Up");
            _instance = this;
            this.container = MainViewController.getInstance().pop_up_container;
            this.level_up_container = MainViewController.getInstance().level_up_container;
            this.specials_container = MainViewController.getInstance().specials_container;
            this.pending_popups = [];
        }
        public static function getInstance():Pop_Up{
            if (_instance == null)
            {
                _instance = new (Pop_Up)();
            };
            return (_instance);
        }

        public function load_popups():void{
            Tracer.out("Pop_Up > load_popups");
            var _local1 = ((Constants.SERVER_SWF + Constants.POPUPS_FILENAME) + ".swf");
            var _local2:URLRequest = new URLRequest(_local1);
            var _local3:Loader = new Loader();
            _local3.contentLoaderInfo.addEventListener(Event.COMPLETE, this.popup_swf_loaded);
            _local3.load(_local2);
        }
        public function popup_swf_loaded(_arg1:Event):void{
            var _local3:int;
            var _local4:Object;
            Tracer.out("Pop_Up > popup_swf_loaded ");
            this.popupAppDomain = (_arg1.target as LoaderInfo).applicationDomain;
            var _local2:int = this.pending_popups.length;
            if (_local2 > 0)
            {
                _local3 = 0;
                while (_local3 < _local2)
                {
                    _local4 = this.pending_popups[_local3];
                    Tracer.out(("   showing pending popup: " + _local4.type));
                    this.display_popup.apply(null, [_local4.type].concat(_local4.args));
                    _local3++;
                };
                this.pending_popups = null;
            };
        }
        public function get_popup(_arg1:String):MovieClip{
            if (this.popupAppDomain == null)
            {
                Tracer.out("   ERROR: popup swf not loaded yet!");
                return (null);
            };
            if (this.popupAppDomain.hasDefinition(_arg1) == false)
            {
                Tracer.out(("   error: no definition found for " + _arg1));
                return (null);
            };
            var _local2:Class = Class(this.popupAppDomain.getDefinition(_arg1));
            var _local3:MovieClip = new (_local2)();
            return (_local3);
        }
        public function display_popup(_arg1:String, ... _args):void{
            var _local4:*;
            Tracer.out(((("Pop_Up > display_popup : " + _arg1) + ", ") + _args.toString()));
            if (this.popupAppDomain == null)
            {
                Tracer.out((("   popup swf not loaded yet!  " + _arg1) + " will show pending load"));
                _local4 = {
                    "type":_arg1,
                    "args":_args
                };
                this.pending_popups.push(_local4);
                if (_arg1 != THREE_DAY_REWARD)
                {
                    MainViewController.getInstance().show_preloader();
                };
                return;
            };
            MainViewController.getInstance().hide_preloader();
            if (this.popupAppDomain.hasDefinition(_arg1) == false)
            {
                Tracer.out(("   error: no definition found for " + _arg1));
                return;
            };
            var _local3:Class = Class(this.popupAppDomain.getDefinition(_arg1));
            this.popup = new (_local3)();
            this.popup.name = _arg1;
            this.add_popup_clip(this.popup);
            if (this.hasOwnProperty(("setup_" + _arg1)))
            {
                this[("setup_" + _arg1)].apply(null, _args);
            };
        }
        public function add_popup_clip(_arg1:MovieClip){
            this.popup = _arg1;
            if (this.popup.name == BIRTHDAY_POPUP)
            {
                this.specials_container.addChild(this.popup);
            } else
            {
                if (this.popup.name == LEVEL_UP)
                {
                    this.level_up_container.addChild(this.popup);
                } else
                {
                    this.container.addChild(this.popup);
                };
            };
            MainViewController.getInstance().show_popup_blocker();
            dispatchEvent(new Event(POPUP_OPENED));
            if (this.popup.close_mc)
            {
                this.popup.close_mc.buttonMode = true;
                this.popup.close_mc.addEventListener(MouseEvent.CLICK, this.remove_pop_up);
            };
            this.center_popup();
        }
        public function alert(_arg1:String):void{
            this.display_popup(ALERT, _arg1);
        }
        public function remove_current_pop_up():void{
            if (this.popup)
            {
                if (this.popup.parent)
                {
                    this.popup.parent.removeChild(this.popup);
                    this.popup = null;
                };
            };
            MainViewController.getInstance().closed_popup();
            if (this.container.numChildren == 0)
            {
                MainViewController.getInstance().hide_popup_blocker();
            };
        }
        public function remove_like_button(_arg1:MouseEvent):void{
            External.hideLikeButton();
            dispatchEvent(new Event(LIKE_BTN_HIDDEN));
        }
        public function remove_pop_up_and_like_button(_arg1:MouseEvent):void{
            this.remove_like_button(_arg1);
            this.remove_pop_up(_arg1);
        }
        public function restore_frame_rate(_arg1:MouseEvent):void{
            MainViewController.getInstance().resume();
        }
        private function center_popup():void{
            if (((((((!((this.popup.name == PARIS_INTRO_1))) && (!((this.popup.name == PARIS_INTRO_2))))) && (!((this.popup.name == LIKE_FASHIONISTA))))) && (!((this.popup.name == LIKE_CONTAINER)))))
            {
                this.popup.x = (Constants.SCREEN_WIDTH / 2);
                this.popup.y = (Constants.SCREEN_HEIGHT / 2);
            };
            this.popup.alpha = 0;
            Tweener.addTween(this.popup, {
                "alpha":1,
                "time":0.3,
                "transition":"linear"
            });
        }
        private function remove_pop_up(_arg1:MouseEvent):void{
            var _local2:MovieClip = (_arg1.currentTarget.parent as MovieClip);
            Tracer.out(("remove_pop_up :" + _local2.name));
            if (_local2.parent)
            {
                Tracer.out("has popup.parent");
                _local2.parent.removeChild(_local2);
            } else
            {
                Tracer.out("no popup.parent");
                return;
            };
            MainViewController.getInstance().closed_popup();
            if (this.container.numChildren == 0)
            {
                MainViewController.getInstance().hide_popup_blocker();
            };
        }
        public function setup_a_list_limit():void{
            var buy_a_list_invite:* = undefined;
            buy_a_list_invite = function (_arg1:MouseEvent):void{
                remove_pop_up(_arg1);
                DataManager.getInstance().buy_a_list_invite();
            };
            this.popup.continue_mc.buttonMode = true;
            this.popup.continue_mc.addEventListener(MouseEvent.CLICK, buy_a_list_invite);
        }
        public function setup_add_floor(floor:int):void{
            var buy_floor:* = undefined;
            buy_floor = function (_arg1:MouseEvent):void{
                remove_pop_up(_arg1);
                FacebookConnector.buy_floor(floor);
            };
            this.popup.buy_btn.buttonMode = true;
            this.popup.buy_btn.addEventListener(MouseEvent.CLICK, buy_floor);
        }
        public function setup_add_floor_confirm():void{
            var share_floor:* = undefined;
            share_floor = function (_arg1:MouseEvent):void{
                remove_pop_up(_arg1);
                FacebookConnector.share_floor(UserData.getInstance().boutique.floorCount);
            };
            this.popup.share_mc.buttonMode = true;
            this.popup.share_mc.addEventListener(MouseEvent.CLICK, share_floor);
            var tf:TextFormat = new TextFormat();
            var f:Font = (MainViewController.getInstance().get_game_asset("gill_sans_bold") as Font);
            tf.font = f.fontName;
            tf.bold = true;
            tf.size = 22;
            tf.leading = 2.6;
            this.popup.floor_txt.defaultTextFormat = tf;
            this.popup.floor_txt.text = (("You've added BoutiqueLevel " + UserData.getInstance().boutique.floorCount) + "!");
        }
        public function setup_alert(str:String, func:Function=null):void{
            var click_ok:* = undefined;
            click_ok = function (_arg1:MouseEvent):void{
                if (func != null)
                {
                    func();
                };
                remove_pop_up(_arg1);
            };
            this.popup.content_text.htmlText = str;
            this.popup.ok_mc.buttonMode = true;
            this.popup.ok_mc.addEventListener(MouseEvent.CLICK, click_ok);
        }
        public function setup_already_own(item:Item):void{
            var send_to_friend:* = undefined;
            send_to_friend = function (_arg1:MouseEvent):void{
                remove_pop_up(_arg1);
                display_popup(FRIEND_BUY, item);
            };
            this.popup.buy_for_friend.buttonMode = true;
            this.popup.skip_mc.buttonMode = true;
            this.popup.skip_mc.addEventListener(MouseEvent.CLICK, this.remove_pop_up);
            this.popup.buy_for_friend.addEventListener(MouseEvent.CLICK, send_to_friend);
        }
        public function setup_already_voted():void{
            this.popup.return_mc.buttonMode = true;
            this.popup.return_mc.addEventListener(MouseEvent.CLICK, this.remove_pop_up);
        }
        public function setup_best_dressed_list():void{
            var enter_look:* = undefined;
            enter_look = function (_arg1:MouseEvent):void{
                remove_pop_up(_arg1);
                DressingRoom.getNewInstance().load();
            };
            this.popup.look_btn.buttonMode = true;
            this.popup.look_btn.addEventListener(MouseEvent.CLICK, enter_look);
        }
        public function setup_birthday_dress():void{
            this.popup.skip_mc.buttonMode = true;
            this.popup.skip_mc.addEventListener(MouseEvent.CLICK, this.remove_pop_up);
        }
        public function setup_birthday_popup():void{
            var share_birthday:* = undefined;
            share_birthday = function (_arg1:MouseEvent):void{
                remove_pop_up(_arg1);
                FacebookConnector.share_birthday();
            };
            this.popup.share_mc.buttonMode = true;
            this.popup.share_mc.addEventListener(MouseEvent.CLICK, share_birthday);
            this.popup.skip_mc.buttonMode = true;
            this.popup.skip_mc.addEventListener(MouseEvent.CLICK, this.remove_pop_up);
        }
        public function setup_bought_cash():void{
            this.popup.ok_mc.buttonMode = true;
            this.popup.ok_mc.addEventListener(MouseEvent.CLICK, this.remove_pop_up);
        }
        public function setup_boutique_directory():void{
            var _local4:Sprite;
            var _local1:Array = CityManager.getInstance().boutiques;
            var _local2:int = _local1.length;
            Tracer.out((("setup_boutique_directory : " + _local2) + " boutiques"));
            var _local3:int;
            while (_local3 < _local2)
            {
                if (_local1[_local3].isOpen != false)
                {
                    if (_local1[_local3].short_name != "dressing_room")
                    {
                        _local4 = this.popup[_local1[_local3].short_name];
                        if (_local4 != null)
                        {
                            _local4.buttonMode = true;
                            _local4.addEventListener(MouseEvent.CLICK, this.load_shop);
                            if (_local1[_local3].level > 0)
                            {
                                this.popup[(_local1[_local3].short_name + "_lock")].visible = (UserData.getInstance().level < _local1[_local3].level);
                            };
                            if (_local1[_local3].mini_level > -1)
                            {
                                this.popup[(_local1[_local3].short_name + "_lock")].visible = (UserData.getInstance().mini_level < _local1[_local3].mini_level);
                            };
                        };
                    };
                };
                _local3++;
            };
        }
        private function load_shop(_arg1:MouseEvent):void{
            var _local2:String = _arg1.currentTarget.name;
            BoutiqueManager.getInstance().setup_boutique_by_name(_local2);
            this.remove_pop_up(_arg1);
        }
        function setup_buy_item_popup(item:PurchasableObject):Sprite{
            var close_popup:* = undefined;
            var close_mc_added:* = undefined;
            var fb_price:int;
            var buy_item_fcash:* = undefined;
            var buy_item_fcredits:* = undefined;
            var this_popup:MovieClip;
            var image_sprite:Sprite;
            var image_loaded:* = undefined;
            var asset_loaded:* = undefined;
            var image_request:URLRequest;
            var image_loader:Loader;
            var ado:AssetDataObject;
            var listener:Object;
            close_popup = function (_arg1:MouseEvent):void{
                remove_like_button(_arg1);
                remove_pop_up(_arg1);
            };
            close_mc_added = function (_arg1:MouseEvent):void{
                remove_like_button(_arg1);
                remove_pop_up(_arg1);
            };
            buy_item_fcash = function (_arg1:MouseEvent):void{
                if ((item is Item))
                {
                    DataManager.getInstance().buy_item((item as Item));
                } else
                {
                    if ((item is Decor))
                    {
                        DataManager.getInstance().buy_decor((item as Decor));
                    };
                };
            };
            buy_item_fcredits = function (_arg1:MouseEvent):void{
                remove_current_pop_up();
                var _local2:UserData = UserData.getInstance();
                if ((item is Item))
                {
                    FacebookConnector.buy_item((item as Item), _local2.do_item_purchase, _local2.cancel_purchase);
                } else
                {
                    if ((item is Decor))
                    {
                        FacebookConnector.buy_decor((item as Decor), null, _local2.cancel_purchase);
                    };
                };
            };
            image_loaded = function (_arg1:Event){
                Tracer.out("image_loaded");
                size_image_sprite(image_loader);
            };
            asset_loaded = function (_arg1:MovieClip, _arg2:String):void{
                Tracer.out(("DecorViewController > assetLoaded: " + _arg2));
                image_sprite.addChild(_arg1);
                size_image_sprite(_arg1);
            };
            var size_image_sprite:* = function (_arg1:DisplayObject){
                Tracer.out("size_image_sprite");
                var _local2:Rectangle = Util.getVisibleBoundingRectForAsset(_arg1);
                _arg1.x = -(_local2.x);
                _arg1.y = -(_local2.y);
                var _local3:Number = (162 / _local2.width);
                var _local4:Number = (182 / _local2.height);
                var _local5:Number = Math.min(_local3, _local4);
                image_sprite.scaleX = _local5;
                image_sprite.scaleY = _local5;
                image_sprite.x = (5 + ((162 - (_local2.width * _local5)) / 2));
                image_sprite.y = (5 + ((182 - (_local2.height * _local5)) / 2));
                if (this_popup.parent)
                {
                    this_popup.swfContainer.addChild(image_sprite);
                };
            };
            var type:String = (((item is Item)) ? "item" : "decor");
            this.popup.close_mc.removeEventListener(MouseEvent.CLICK, this.remove_pop_up);
            this.popup.close_mc.addEventListener(MouseEvent.CLICK, close_popup);
            this.popup.close_mc.visible = true;
            this.popup.buy_fcredits_btn.visible = true;
            this.popup.buy_fcash_btn.visible = true;
            this.popup.buy_fcash_tip.visible = true;
            this.popup.mc_Added.visible = false;
            this.popup.header_text.text = item.name;
            this.popup.content_text.htmlText = item.description;
            if (item.fb_credits)
            {
                this.popup.buy_fcash_btn.visible = false;
                this.popup.buy_fcredits_btn.y = (this.popup.buy_fcredits_btn.y - (this.popup.buy_fcredits_btn.height * 0.66));
            } else
            {
                this.popup.buy_fcash_btn.buttonMode = true;
                this.popup.buy_fcash_btn.mouseChildren = false;
                this.popup.buy_fcash_btn.addEventListener(MouseEvent.CLICK, buy_item_fcash);
                this.popup.buy_fcash_btn.price_txt.text = String(item.price);
            };
            this.popup.buy_fcredits_btn.buttonMode = true;
            this.popup.buy_fcredits_btn.mouseChildren = false;
            this.popup.buy_fcredits_btn.addEventListener(MouseEvent.CLICK, buy_item_fcredits);
            this.popup.mc_Added.buttonMode = true;
            this.popup.mc_Added.mouseChildren = false;
            this.popup.mc_Added.addEventListener(MouseEvent.CLICK, close_mc_added);
            if ((item is Item))
            {
                fb_price = (((item.level)>0) ? Math.ceil((item.price / 100)) : Math.floor((item.price / 100)));
                if (fb_price == 0)
                {
                    fb_price = 1;
                };
            } else
            {
                if ((item is Decor))
                {
                    fb_price = Decor(item).cost_fbcredits;
                };
            };
            this.popup.buy_fcredits_btn.price_txt.text = String(fb_price);
            this_popup = this.popup;
            image_sprite = new Sprite();
            Tracer.out(("loading image for buy popup.  item is Decor? " + (item is Decor)));
            if ((item is Item))
            {
                try
                {
                    trace(("Image url   " + item.swf));
                    if ((((item.swf.indexOf(".png") > -1)) || ((item.swf.indexOf(".swf") > -1))))
                    {
                        image_request = new URLRequest(item.swf);
                        image_loader = new Loader();
                        image_loader.load(image_request);
                        image_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, image_loaded);
                        image_sprite.addChild(image_loader);
                    } else
                    {
                        (size_image_sprite(image_sprite));
                    };
                } catch(e:Error)
                {
                    trace(e);
                    return (image_sprite);
                };
            };
            if ((item is Decor))
            {
                ado = new AssetDataObject();
                ado.parseURL(item.swf);
                listener = {"assetLoaded":asset_loaded};
                AssetManager.getInstance().getAssetFor(ado, listener);
            };
            return (image_sprite);
        }
        public function HideCloseButton():void{
            if (this.popup)
            {
                trace("Hide Close button called");
                this.popup.buy_fcredits_btn.visible = false;
                this.popup.buy_fcash_btn.visible = false;
                this.popup.buy_fcash_tip.visible = false;
                this.popup.mc_Added.visible = true;
            };
        }
        public function setup_buy_item(item:PurchasableObject):void{
            var image_sprite:Sprite;
            Tracer.out(((("Pop_Up > setup_buy_item : swf is " + item.swf) + ", level is ") + item.level));
            Tracer.out(((("Pop_Up > setup_buy_item : daily_free_give is " + UserData.getInstance().daily_free_give) + ", daily_free_request is ") + UserData.getInstance().daily_free_request));
            image_sprite = this.setup_buy_item_popup(item);
            Tracer.out(("item is Item = " + (item is Item)));
            this.popup.buy_fcash_tip.visible = false;
            this.popup.get_btn.visible = false;
            if ((((((item is Item)) && ((item.level == 0)))) && ((UserData.getInstance().daily_free_give == false))))
            {
                var give_item:* = function (_arg1:MouseEvent):void{
                    remove_pop_up_and_like_button(_arg1);
                    FacebookConnector.openGiftFriendSelector((item as Item), Constants.REQUEST_FREE_ITEM);
                };
                this.popup.get_btn.visible = true;
                this.popup.give_btn.buttonMode = true;
                this.popup.give_btn.addEventListener(MouseEvent.CLICK, give_item);
            } else
            {
                var send_item:* = function (_arg1:MouseEvent):void{
                    remove_pop_up_and_like_button(_arg1);
                    display_popup(FRIEND_BUY, item, image_sprite);
                };
                this.popup.give_btn.visible = false;
                this.popup.give_free_tip.visible = false;
                this.popup.give_friend_btn.buttonMode = true;
                this.popup.give_friend_btn.addEventListener(MouseEvent.CLICK, send_item);
            };
            if ((((item is Item)) && (UserData.getInstance().owns(item))))
            {
                this.popup.buy_fcash_btn.visible = false;
                this.popup.buy_fcredits_btn.visible = false;
                this.popup.get_btn.visible = false;
                this.popup.get_free_tip.visible = false;
                this.popup.req_friend_btn.visible = false;
                this.popup.post_tip.visible = false;
                this.popup.give_friend_btn.visible = false;
                this.popup.give_btn.x = (this.popup.give_btn.x + 88);
                this.popup.give_free_tip.x = (this.popup.give_free_tip.x + 88);
                return;
            };
            this.popup.own_txt.visible = false;
            if ((((((item is Item)) && ((item.level == 0)))) && ((UserData.getInstance().daily_free_request == false))))
            {
                var request_free_item:* = function (_arg1:MouseEvent):void{
                    remove_pop_up_and_like_button(_arg1);
                    DataManager.getInstance().request_free_item(item.id);
                };
                this.popup.get_btn.buttonMode = true;
                this.popup.get_btn.addEventListener(MouseEvent.CLICK, request_free_item);
                this.popup.post_tip.visible = false;
            } else
            {
                var request_item:* = function (_arg1:MouseEvent):void{
                    remove_pop_up_and_like_button(_arg1);
                    display_popup(FRIEND_REQUEST, item, image_sprite);
                };
                this.popup.get_btn.visible = false;
                this.popup.get_free_tip.visible = false;
                Tracer.out(("popup.req_friend_btn = " + this.popup.req_friend_btn));
                this.popup.req_friend_btn.buttonMode = true;
                this.popup.req_friend_btn.addEventListener(MouseEvent.CLICK, request_item);
            };
            if ((((((((item is Item)) && (this.popup.buy_fcash_btn.visible))) && (UserData.getInstance().first_time_visit()))) && ((Tracker.first_time_buy_item == false))))
            {
                this.popup.buy_fcash_tip.visible = true;
            };
        }
        public function setup_buy_item_confirm(_arg1:PurchasableObject):void{
        }
        public function setup_conversion(credits:int):void{
            var convert:* = undefined;
            convert = function (_arg1:MouseEvent):void{
                remove_pop_up(_arg1);
                FacebookConnector.buy_fashion_cash(credits, null);
            };
            this.popup.credits_txt.text = String(credits);
            this.popup.buy_btn.buttonMode = true;
            this.popup.buy_btn.addEventListener(MouseEvent.CLICK, convert);
        }
        public function setup_duplicate_look():void{
            this.popup.continue_btn.buttonMode = true;
            this.popup.continue_btn.addEventListener(MouseEvent.CLICK, this.remove_pop_up);
        }
        public function setup_empty_closet():void{
            var go_city:* = undefined;
            go_city = function (_arg1:MouseEvent):void{
                Main.getInstance().set_section(Constants.SECTION_CITY);
            };
            this.popup.shop_btn.buttonMode = true;
            this.popup.shop_btn.addEventListener(MouseEvent.CLICK, go_city);
        }
        public function setup_enter_look_confirm():void{
            var model:UserBoutiqueModelViewController;
            var mp:DisplayObjectContainer;
            var close_popup:Function;
            var go_runway:Function;
            var check_publish:Function = function ():Boolean{
                return ((popup.checkbox_txt.text == "X"));
            };
            close_popup = function (_arg1:MouseEvent):void{
                mp.addChild(model);
                remove_pop_up(_arg1);
                if (UserData.getInstance().first_time_visit())
                {
                    if (check_publish())
                    {
                        if (Tracker.first_time_share == false)
                        {
                            Tracker.first_time_share = true;
                            Tracker.track_first_time(Tracker.SHARE_LOOK);
                        };
                    } else
                    {
                        if (Tracker.first_time_skip == false)
                        {
                            Tracker.first_time_skip = true;
                            Tracker.track_first_time(Tracker.SKIP_PUBLISH);
                        };
                    };
                };
                if (check_publish())
                {
                    FacebookConnector.post_look_photo(PNGGenerator.generate_look_bitmap(ModelUIController.current_instance().model_vc.avatar_controller), "", true);
                };
                if (popup.name != Pop_Up.ENTER_LOOK_CONFIRM_MB)
                {
                    Runway.getInstance().load(Runway.FROM_DRESSING_ROOM);
                };
            };
            var setup_publish_checkbox:Function = function (){
                var toggle_publish:Function;
                toggle_publish = function (_arg1:MouseEvent):void{
                    if (popup.checkbox_txt.text == "X")
                    {
                        popup.checkbox_txt.text = "";
                    } else
                    {
                        popup.checkbox_txt.text = "X";
                    };
                };
                popup.publish_btn.buttonMode = true;
                popup.publish_btn.addEventListener(MouseEvent.CLICK, toggle_publish);
                popup.checkbox_txt.text = "";
            };
            this.popup.close_btn.buttonMode = true;
            this.popup.close_btn.addEventListener(MouseEvent.CLICK, close_popup);
            (setup_publish_checkbox());
            model = ModelUIController.current_instance().model_vc;
            Tracer.out(((("setup_enter_look_confirm.  model.visible is " + model.visible) + ", model.alpha is ") + model.alpha));
            mp = model.parent;
            this.popup.model_container.addChild(model);
            if (this.popup.name == Pop_Up.ENTER_LOOK_CONFIRM_MB)
            {
                go_runway = function (_arg1:MouseEvent):void{
                    close_popup(_arg1);
                    Runway.getInstance().load(Runway.FROM_DRESSING_ROOM);
                };
                Util.simpleButton(this.popup.runway_btn, go_runway, false);
            };
        }
        public function setup_enter_look_confirm_mb(){
            this.setup_enter_look_confirm();
        }
        public function setup_faceoff_intro():void{
            this.popup.ok_btn.buttonMode = true;
            this.popup.ok_btn.addEventListener(MouseEvent.CLICK, this.remove_pop_up);
        }
        public function setup_first_faceoff_win():void{
            var get_faceoff:* = undefined;
            get_faceoff = function (_arg1:MouseEvent):void{
                FaceoffController.getInstance().get_faceoff();
            };
            this.popup.ok_btn.buttonMode = true;
            this.popup.ok_btn.addEventListener(MouseEvent.CLICK, this.remove_pop_up);
            this.popup.ok_btn.addEventListener(MouseEvent.CLICK, get_faceoff);
        }
        public function setup_free_item_request_confirm():void{
            var open_appssavvy:* = undefined;
            open_appssavvy = function (_arg1:MouseEvent):void{
                External.showAppssavvy(External.AS_REQUEST_FREE);
            };
            this.popup.ok_btn.buttonMode = true;
            this.popup.ok_btn.addEventListener(MouseEvent.CLICK, this.remove_pop_up);
            this.popup.ok_btn.addEventListener(MouseEvent.CLICK, open_appssavvy);
        }
        public function setup_friend_already_has():void{
            this.popup.ok_btn.buttonMode = true;
            this.popup.ok_btn.addEventListener(MouseEvent.CLICK, this.remove_pop_up);
        }
        public function setup_friend_buy(item:PurchasableObject, image_sprite:Sprite=null):void{
            var this_popup:MovieClip;
            var fb_price:int;
            var buy_item_fcash:* = undefined;
            var buy_item_fcredits:* = undefined;
            var image_request:URLRequest;
            var image_loader:Loader;
            var ado:AssetDataObject;
            var listener:Object;
            buy_item_fcash = function (_arg1:MouseEvent):void{
                if (this_popup.list_box.selectedItem == null)
                {
                    display_popup(ALERT, "Oops!  Please select a friend first!");
                    return;
                };
                remove_pop_up(_arg1);
                Tracer.out(("buy_item for friend fcash: item is " + item));
                var _local2:String = this_popup.list_box.selectedItem.id;
                DataManager.getInstance().buy_for_friend(_local2, item);
            };
            buy_item_fcredits = function (e:MouseEvent):void{
                var show_confirm_popup:* = undefined;
                show_confirm_popup = function ():void{
                    display_popup(Pop_Up.FRIEND_BUY_CONFIRM);
                };
                if (this_popup.list_box.selectedItem == null)
                {
                    display_popup(ALERT, "Oops!  Please select a friend first!");
                    return;
                };
                remove_pop_up(e);
                var friend_id:String = this_popup.list_box.selectedItem.id;
                if ((item is Item))
                {
                    FacebookConnector.gift_item((item as Item), friend_id, show_confirm_popup, null);
                } else
                {
                    if ((item is Decor))
                    {
                        FacebookConnector.gift_decor((item as Decor), friend_id, show_confirm_popup, null);
                    };
                };
            };
            this.popup.name = "friend_popup";
            this.popup.header_text.text = item.name;
            this_popup = this.popup;
            if (image_sprite)
            {
                this_popup.swfContainer.addChild(image_sprite);
            } else
            {
                var image_loaded:* = function (_arg1:Event){
                    Tracer.out("image_loaded");
                    size_image_sprite(image_loader);
                };
                var asset_loaded:* = function (_arg1:MovieClip, _arg2:String):void{
                    Tracer.out(("DecorViewController > assetLoaded: " + _arg2));
                    image_sprite.addChild(_arg1);
                    size_image_sprite(_arg1);
                };
                var size_image_sprite:* = function (_arg1:DisplayObject){
                    Tracer.out("size_image_sprite");
                    var _local2:Rectangle = Util.getVisibleBoundingRectForAsset(_arg1);
                    _arg1.x = -(_local2.x);
                    _arg1.y = -(_local2.y);
                    var _local3:Number = (162 / _local2.width);
                    var _local4:Number = (182 / _local2.height);
                    var _local5:Number = Math.min(_local3, _local4);
                    image_sprite.scaleX = _local5;
                    image_sprite.scaleY = _local5;
                    image_sprite.x = (5 + ((162 - (_local2.width * _local5)) / 2));
                    image_sprite.y = (5 + ((182 - (_local2.height * _local5)) / 2));
                    if (this_popup.parent)
                    {
                        this_popup.swfContainer.addChild(image_sprite);
                    };
                };
                image_sprite = new Sprite();
                if ((item is Item))
                {
                    image_request = new URLRequest(item.swf);
                    image_loader = new Loader();
                    image_loader.load(image_request);
                    image_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, image_loaded);
                    image_sprite.addChild(image_loader);
                };
                if ((item is Decor))
                {
                    ado = new AssetDataObject();
                    ado.parseURL(item.swf);
                    listener = {"assetLoaded":asset_loaded};
                    AssetManager.getInstance().getAssetFor(ado, listener);
                };
            };
            this.popup.list_box.labelField = "name";
            this.popup.list_box.rowHeight = 60;
            this.popup.list_box.iconField = "iconSource";
            var friends:Vector.<Friend> = UserData.getInstance().app_friends;
            friends.map(this.load_friend_pic);
            this.popup.buy_fcash_btn.buttonMode = true;
            this.popup.buy_fcash_btn.addEventListener(MouseEvent.CLICK, buy_item_fcash);
            this.popup.buy_fcash_btn.price_txt.text = String(item.price);
            this.popup.buy_fcredits_btn.buttonMode = true;
            this.popup.buy_fcredits_btn.addEventListener(MouseEvent.CLICK, buy_item_fcredits);
            if ((item is Item))
            {
                fb_price = (((item.level)>0) ? Math.ceil((item.price / 100)) : Math.floor((item.price / 100)));
                if (fb_price == 0)
                {
                    fb_price = 1;
                };
            } else
            {
                if ((item is Decor))
                {
                    fb_price = Decor(item).cost_fbcredits;
                };
            };
            this.popup.buy_fcredits_btn.price_txt.text = String(fb_price);
        }
        public function setup_friend_buy_confirm():void{
            this.popup.ok_btn.buttonMode = true;
            this.popup.ok_btn.addEventListener(MouseEvent.CLICK, this.remove_pop_up);
        }
        public function setup_friend_message_buy(friend_id:String, item:PurchasableObject, itemPng:String, buy_item_complete:Function, buy_item_fail:Function):void{
            var image_loader:Loader;
            var image_loaded:* = undefined;
            var reset_message:* = undefined;
            var buy_item_fcash:* = undefined;
            image_loaded = function (_arg1:Event){
                Util.scaleAndCenterDisplayObject(image_loader, 162, 182);
            };
            reset_message = function (_arg1:Event){
                buy_item_fail(_local2);
            };
            buy_item_fcash = function (_arg1:MouseEvent):void{
                remove_pop_up(_arg1);
                DataManager.getInstance().buy_for_friend(friend_id, item, buy_item_complete, buy_item_fail);
            };
            this.popup.header_text.text = item.name;
            var image_request:URLRequest = new URLRequest(itemPng);
            image_loader = new Loader();
            image_loader.load(image_request);
            image_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, image_loaded);
            this.popup.image.addChild(image_loader);
            this.popup.close_mc.addEventListener(MouseEvent.CLICK, reset_message);
            this.popup.buy_fcash_btn.buttonMode = true;
            this.popup.buy_fcash_btn.addEventListener(MouseEvent.CLICK, buy_item_fcash);
            this.popup.buy_fcash_btn.price_txt.text = String(item.price);
        }
        public function setup_friend_request(item:PurchasableObject, image_sprite:Sprite):void{
            var this_popup:MovieClip;
            var request_item:* = undefined;
            request_item = function (_arg1:MouseEvent):void{
                if (this_popup.list_box.selectedItem == null)
                {
                    display_popup(ALERT, "Oops!  Please select a friend first!");
                    return;
                };
                remove_pop_up(_arg1);
                var _local2:String = this_popup.list_box.selectedItem.id;
                DataManager.getInstance().ask_friend(_local2, item);
            };
            this.popup.name = "friend_popup";
            this.popup.header_text.text = item.name;
            this.popup.cash_text.text = item.price;
            this.popup.swfContainer.addChild(image_sprite);
            this.popup.close_mc.buttonMode = true;
            this.popup.close_mc.addEventListener(MouseEvent.CLICK, this.remove_pop_up);
            this.popup.ask.buttonMode = true;
            this.popup.ask.addEventListener(MouseEvent.CLICK, request_item);
            this.popup.list_box.labelField = "name";
            this.popup.list_box.rowHeight = 60;
            this.popup.list_box.iconField = "iconSource";
            var friends:Vector.<Friend> = UserData.getInstance().app_friends;
            friends.map(this.load_friend_pic);
            this_popup = this.popup;
        }
        public function setup_friend_request_confirm():void{
            var addCash:* = undefined;
            addCash = function (_arg1:MouseEvent):void{
                remove_pop_up(_arg1);
                External.addcash_window();
            };
            this.popup.more_btn.buttonMode = true;
            this.popup.more_btn.addEventListener(MouseEvent.CLICK, addCash);
        }
        private function load_friend_pic(_arg1:Friend, _arg2:int, _arg3:Vector.<Friend>):void{
            var _local4:MovieClip = (MainViewController.getInstance().get_game_asset("friend_img_loader") as MovieClip);
            var _local5:Sprite = new Sprite();
            _local4.addChild(_local5);
            var _local6:ImageLoader = new ImageLoader(_arg1.pic, _local5, 50, 50);
            var _local7:Object = {
                "name":_arg1.name,
                "id":_arg1.user_id,
                "iconSource":_local4
            };
            var _local8:MovieClip = (this.container.getChildByName("friend_popup") as MovieClip);
            _local8.list_box.dataProvider.addItem(_local7);
        }
        public function setup_hire_agent():void{
            var buy_agent:* = undefined;
            buy_agent = function (_arg1:MouseEvent){
                remove_pop_up(_arg1);
                Tracker.track("click", "hire_pr_agent");
                FacebookConnector.hire_pr_agent();
            };
            this.popup.buy_btn.buttonMode = true;
            this.popup.buy_btn.addEventListener(MouseEvent.CLICK, buy_agent);
        }
        public function setup_judge_joel():void{
            var openFanPage:* = undefined;
            openFanPage = function (){
                navigateToURL(new URLRequest(Constants.JOEL_URL), "_blank");
            };
            this.popup.close_mc.addEventListener(MouseEvent.CLICK, this.remove_pop_up_and_like_button);
            this.popup.fanBtn.buttonMode = true;
            this.popup.fanBtn.mouseChildren = false;
            this.popup.fanBtn.addEventListener(MouseEvent.CLICK, openFanPage);
            External.initLikeButton("judge");
            External.showLikeButton();
        }
        public function setup_level_too_low(type:String, item:Object):void{
            var diff:int;
            var buy_fast_pass:* = undefined;
            buy_fast_pass = function (_arg1:MouseEvent):void{
                remove_pop_up(_arg1);
                if (diff > UserData.getInstance().fcash)
                {
                    display_popup(Pop_Up.NEED_MORE_CASH);
                    return;
                };
                if (type == "item")
                {
                    Tracer.out(("storing pending purchase: " + item.name));
                    pending_item_purchase = item;
                    pending_boutique = null;
                } else
                {
                    if (type == "boutique")
                    {
                        Tracer.out(("storing pending boutique: " + item.name));
                        pending_boutique = item.name;
                        pending_item_purchase = null;
                    };
                };
                DataManager.getInstance().buy_points(diff);
            };
            if (UserData.getInstance().shopping_welcome)
            {
                this.remove_current_pop_up();
                this.display_popup(LEVEL_TOO_LOW_FIRST_TIME, type, item);
                return;
            };
            if (item.level)
            {
                diff = ((item.level * 1000) - UserData.getInstance().points);
            } else
            {
                if (item.mini_level)
                {
                    diff = ((item.mini_level - UserData.getInstance().mini_level) * 100);
                };
            };
            this.popup.skip_btn.buttonMode = true;
            this.popup.skip_btn.addEventListener(MouseEvent.CLICK, this.remove_pop_up);
            this.popup.buy_fast_pass.buttonMode = true;
            this.popup.buy_fast_pass.addEventListener(MouseEvent.CLICK, buy_fast_pass);
            var tf:TextFormat = new TextFormat();
            tf.font = "Arial";
            tf.bold = true;
            this.popup.points_txt.defaultTextFormat = tf;
            if (item.mini_level)
            {
                this.popup.points_txt.text = (("*Your Fast Pass to unlock this Boutique is " + diff) + " FashionCash");
            } else
            {
                this.popup.points_txt.text = (("*Your Fast Pass to get to this level is " + diff) + " FashionCash");
            };
            if (type == "item")
            {
                this.popup.level_txt.gotoAndStop(1);
            } else
            {
                if (type == "boutique")
                {
                    if (item.level)
                    {
                        this.popup.level_txt.gotoAndStop(2);
                    } else
                    {
                        this.popup.level_txt.gotoAndStop(4);
                    };
                };
            };
        }
        public function setup_level_too_low_first_time(_arg1:String, _arg2:Object):void{
            this.popup.ok_btn.buttonMode = true;
            this.popup.ok_btn.addEventListener(MouseEvent.CLICK, this.remove_pop_up);
            var _local3:TextFormat = new TextFormat();
            _local3.font = "Arial";
            _local3.bold = true;
            _local3.size = 30;
            this.popup.level_txt.defaultTextFormat = _local3;
            if (_arg1 == "boutique")
            {
                this.popup.level_txt.text = (("You need to be level " + _arg2.level) + " to enter this boutique.");
            } else
            {
                if (_arg1 == "paris")
                {
                    this.popup.level_txt.text = (("You need to be level " + _arg2.level) + " to fly to Paris.");
                } else
                {
                    this.popup.level_txt.text = (("You need to be level " + _arg2.level) + " to buy this item.");
                };
            };
        }
        public function setup_level_up(_arg1:Boolean=false):void{
            var _local4:int;
            this.popup.x = (this.popup.stage.stageWidth / 2);
            this.popup.y = (this.popup.stage.stageHeight / 2);
            this.popup.share_mc.buttonMode = true;
            this.popup.share_mc.addEventListener(MouseEvent.CLICK, this.share_level);
            this.popup.skip_mc.buttonMode = true;
            this.popup.skip_mc.addEventListener(MouseEvent.CLICK, this.remove_pop_up);
            var _local2:int = UserData.getInstance().level;
            var _local3:int = UserData.getInstance().offline_leveling_reward;
            if (_arg1)
            {
                if ((((_local2 > 0)) && ((_local3 > 0))))
                {
                    this.popup.level_txt.text = (((("You are now Level " + _local2) + ", and have earned ") + _local3) + " Fashion Cash !");
                    _local4 = 3;
                    this.popup.welcome_mc.visible = false;
                } else
                {
                    this.popup.level_txt.text = "";
                    this.popup.thanks_txt.y = -135;
                    this.popup.congratulations_mc.visible = false;
                    this.popup.share_mc.visible = false;
                    this.popup.skip_mc.visible = false;
                    if (UserData.getInstance().first_time_visit())
                    {
                        _local4 = 4;
                    } else
                    {
                        _local4 = 3;
                        this.popup.welcome_mc.visible = false;
                    };
                };
            } else
            {
                this.popup.level_txt.text = (("You have reached Level " + _local2) + " and earned 25 Fashion Cash !");
                _local4 = (((_local2)==Constants.PARIS_LEVEL) ? 2 : 1);
                this.popup.welcome_mc.visible = false;
            };
            this.popup.bottom_text.gotoAndStop(_local4);
            this.level_up_pending_action();
        }
        public function setup_level_3():void{
            this.setup_level_popup();
        }
        public function setup_level_4():void{
            this.setup_level_popup();
        }
        public function setup_level_5():void{
            this.setup_level_popup();
        }
        public function setup_level_6():void{
            this.setup_level_popup();
        }
        public function setup_level_7():void{
            this.setup_level_popup();
        }
        public function setup_level_8():void{
            this.setup_level_popup();
        }
        public function setup_level_9():void{
            this.setup_level_popup();
        }
        public function setup_level_paris():void{
            this.setup_level_popup();
        }
        function setup_level_popup():void{
            this.popup.share_mc.buttonMode = true;
            this.popup.share_mc.addEventListener(MouseEvent.CLICK, this.share_level);
            this.popup.skip_mc.buttonMode = true;
            this.popup.skip_mc.addEventListener(MouseEvent.CLICK, this.remove_pop_up);
            this.level_up_pending_action();
        }
        function share_level(_arg1:MouseEvent):void{
            Tracer.out("share_level");
            this.remove_pop_up(_arg1);
            FacebookConnector.share_level();
        }
        public function level_up_pending_action():void{
            var _local1:UserData;
            var _local2:Item;
            Tracer.out("Pop_Up > level_up_pending_action ");
            if (this.pending_item_purchase)
            {
                _local1 = UserData.getInstance();
                _local2 = (_local1.pending_purchase as Item);
                if (_local2.fb_credits)
                {
                    FacebookConnector.buy_item(_local2, _local1.do_item_purchase, _local1.cancel_purchase);
                } else
                {
                    DataManager.getInstance().buy_item(_local2);
                };
                this.pending_item_purchase = null;
            } else
            {
                if (this.pending_boutique)
                {
                    this.popup.no_remove = true;
                    BoutiqueManager.getInstance().setup_boutique_by_name(this.pending_boutique);
                    this.pending_boutique = null;
                } else
                {
                    if (this.pending_flight)
                    {
                        this.popup.no_remove = true;
                        CityParis.getInstance().load_zoom();
                        this.pending_flight = false;
                    };
                };
            };
        }
        public function setup_like_fashionista():void{
            var show_like:* = undefined;
            show_like = function (_arg1:MouseEvent):void{
                remove_pop_up(_arg1);
                display_popup(LIKE_CONTAINER);
                DataManager.getInstance().show_like_button();
            };
            this.popup.show_btn.buttonMode = true;
            this.popup.show_btn.addEventListener(MouseEvent.CLICK, show_like);
        }
        public function setup_like_container():void{
            var hide_like:* = undefined;
            hide_like = function (_arg1:MouseEvent):void{
                External.hideXFBMLLikeButton();
            };
            External.showXFBMLLikeButton();
            this.popup.close_mc.addEventListener(MouseEvent.CLICK, hide_like);
        }
        public function setup_looks_limit():void{
            var buy_entry:* = undefined;
            var go_city:* = undefined;
            var go_runway:* = undefined;
            buy_entry = function (_arg1:MouseEvent):void{
                remove_pop_up(_arg1);
                DataManager.getInstance().buy_entry();
            };
            go_city = function (_arg1:MouseEvent):void{
                Main.getInstance().set_section(Constants.SECTION_CITY);
            };
            go_runway = function (_arg1:MouseEvent):void{
                Runway.getInstance().load(Runway.SHOW_WELCOME);
            };
            this.popup.runway_mc.buttonMode = true;
            this.popup.runway_mc.addEventListener(MouseEvent.CLICK, go_runway);
            this.popup.continue_mc.buttonMode = true;
            this.popup.continue_mc.addEventListener(MouseEvent.CLICK, buy_entry);
            this.popup.city_mc.buttonMode = true;
            this.popup.city_mc.addEventListener(MouseEvent.CLICK, go_city);
        }
        public function setup_make_me_a_star():void{
            var invite_friends:* = undefined;
            invite_friends = function (_arg1:MouseEvent):void{
                Tracer.out("clicked ok btn");
                remove_pop_up(_arg1);
                FacebookConnector.invite_friends("Win 50 FashionCash for each NEW friend who plays!");
            };
            this.popup.okBtn.buttonMode = true;
            this.popup.okBtn.addEventListener(MouseEvent.CLICK, invite_friends);
        }
        public function setup_my_boutique_decorate(callback:Function):void{
            var track_decorate:* = undefined;
            track_decorate = function (_arg1:MouseEvent):void{
                remove_pop_up(_arg1);
                if (callback != null)
                {
                    callback();
                };
            };
            this.popup.decorate_btn.buttonMode = true;
            this.popup.decorate_btn.addEventListener(MouseEvent.CLICK, track_decorate);
        }
        public function setup_my_boutique_dress_up(callback:Function):void{
            var click_dress:* = undefined;
            click_dress = function (_arg1:MouseEvent):void{
                remove_pop_up(_arg1);
                if (callback != null)
                {
                    callback();
                };
            };
            this.popup.dress_btn.buttonMode = true;
            this.popup.dress_btn.addEventListener(MouseEvent.CLICK, click_dress);
        }
        public function setup_my_boutique_welcome_back(earnings:int){
            var this_popup:MovieClip;
            var toggle_publish:* = undefined;
            var check_publish:* = undefined;
            toggle_publish = function (_arg1:MouseEvent):void{
                if (this_popup.checkbox_txt.text == "X")
                {
                    this_popup.checkbox_txt.text = "";
                } else
                {
                    this_popup.checkbox_txt.text = "X";
                };
            };
            check_publish = function (_arg1:MouseEvent):void{
                if (this_popup.checkbox_txt.text == "X")
                {
                    FacebookConnector.share_my_boutique_earnings(earnings);
                };
                remove_pop_up(_arg1);
            };
            Tracer.out("Pop_Up > setup_my_boutique_welcome_back");
            var tf:TextFormat = new TextFormat();
            tf.font = "Arial";
            tf.bold = true;
            this.popup.earningsTxt.defaultTextFormat = tf;
            this.popup.earningsTxt.text = (String(earnings) + " FashionCash");
            this.popup.publish_btn.buttonMode = true;
            this.popup.publish_btn.addEventListener(MouseEvent.CLICK, toggle_publish);
            this.popup.checkbox_txt.text = "";
            this_popup = this.popup;
            this.popup.ok_btn.buttonMode = true;
            this.popup.ok_btn.addEventListener(MouseEvent.CLICK, check_publish);
        }
        public function setup_need_more_cash():void{
            var open_sr:* = undefined;
            open_sr = function (_arg1:MouseEvent):void{
                remove_pop_up(_arg1);
                External.addcash_window();
            };
            this.popup.buy_btn.buttonMode = true;
            this.popup.buy_btn.addEventListener(MouseEvent.CLICK, open_sr);
        }
        public function setup_no_looks():void{
            var goto_dressing_room:* = undefined;
            goto_dressing_room = function (_arg1:MouseEvent):void{
                remove_pop_up(_arg1);
                DressingRoom.getNewInstance().load();
            };
            this.popup.continue_mc.buttonMode = true;
            this.popup.continue_mc.addEventListener(MouseEvent.CLICK, goto_dressing_room);
            this.popup.skip_mc.buttonMode = true;
            this.popup.skip_mc.addEventListener(MouseEvent.CLICK, this.remove_pop_up, false, 0, true);
        }
        public function setup_no_a_list_looks():void{
            var show_friend_invite:* = undefined;
            show_friend_invite = function (_arg1:MouseEvent):void{
                remove_pop_up(_arg1);
                FacebookConnector.invite_friends();
            };
            this.popup.continue_mc.buttonMode = true;
            this.popup.continue_mc.addEventListener(MouseEvent.CLICK, show_friend_invite);
            this.popup.skip_mc.buttonMode = true;
            this.popup.skip_mc.addEventListener(MouseEvent.CLICK, this.remove_pop_up, false, 0, true);
        }
        public function setup_no_a_lister_looks():void{
            var show_friend_invite:* = undefined;
            show_friend_invite = function (_arg1:MouseEvent):void{
                remove_pop_up(_arg1);
                FacebookConnector.invite_friends();
            };
            this.popup.continue_mc.buttonMode = true;
            this.popup.continue_mc.addEventListener(MouseEvent.CLICK, show_friend_invite);
            this.popup.skip_mc.buttonMode = true;
            this.popup.skip_mc.addEventListener(MouseEvent.CLICK, this.remove_pop_up, false, 0, true);
        }
        public function setup_no_my_looks():void{
            var goto_dressing_room:* = undefined;
            goto_dressing_room = function (_arg1:MouseEvent):void{
                remove_pop_up(_arg1);
                DressingRoom.getNewInstance().load();
            };
            this.popup.continue_mc.buttonMode = true;
            this.popup.continue_mc.addEventListener(MouseEvent.CLICK, goto_dressing_room);
            this.popup.skip_mc.buttonMode = true;
            this.popup.skip_mc.addEventListener(MouseEvent.CLICK, this.remove_pop_up, false, 0, true);
        }
        public function setup_no_team_looks():void{
            this.setup_no_a_list_looks();
        }
        public function setup_paris_insufficient_level():void{
            var diff:int;
            var buy_fast_pass:* = undefined;
            buy_fast_pass = function (_arg1:MouseEvent):void{
                remove_pop_up(_arg1);
                pending_flight = true;
                DataManager.getInstance().buy_points(diff);
            };
            diff = ((Constants.PARIS_LEVEL * 1000) - UserData.getInstance().points);
            var tf:TextFormat = new TextFormat();
            tf.font = "Arial";
            tf.bold = true;
            this.popup.points_txt.defaultTextFormat = tf;
            var s:String = (((diff)==1) ? (diff + " point") : (diff + " points"));
            this.popup.points_txt.text = (("Oops, you need " + s) + " to fly to Fantasy Paris!");
            this.popup.buy_fast_pass.buttonMode = true;
            this.popup.buy_fast_pass.addEventListener(MouseEvent.CLICK, buy_fast_pass);
        }
        public function setup_paris_intro_1():void{
            var display_intro_2:* = undefined;
            display_intro_2 = function (_arg1:MouseEvent):void{
                remove_pop_up(_arg1);
                display_popup(Pop_Up.PARIS_INTRO_2);
            };
            this.popup.ok_btn.buttonMode = true;
            this.popup.ok_btn.addEventListener(MouseEvent.CLICK, display_intro_2);
        }
        public function setup_paris_intro_2():void{
            var open_giorgios:* = undefined;
            open_giorgios = function (_arg1:MouseEvent):void{
                remove_pop_up(_arg1);
                BoutiqueManager.getInstance().setup_boutique_by_name("giorgios");
            };
            this.popup.ok_btn.buttonMode = true;
            this.popup.ok_btn.addEventListener(MouseEvent.CLICK, open_giorgios);
        }
        public function setup_paris_welcome():void{
            var share_paris:* = undefined;
            var display_intro_1:* = undefined;
            share_paris = function (_arg1:MouseEvent):void{
                remove_pop_up(_arg1);
                display_popup(Pop_Up.PARIS_INTRO_1);
                FacebookConnector.share_paris();
            };
            display_intro_1 = function (_arg1:Event):void{
                display_popup(Pop_Up.PARIS_INTRO_1);
            };
            this.popup.share_mc.buttonMode = true;
            this.popup.share_mc.addEventListener(MouseEvent.CLICK, share_paris);
            this.popup.close_mc.addEventListener(MouseEvent.CLICK, display_intro_1);
            this.popup.skip_mc.buttonMode = true;
            this.popup.skip_mc.addEventListener(MouseEvent.CLICK, this.remove_pop_up);
            this.popup.skip_mc.addEventListener(MouseEvent.CLICK, display_intro_1);
        }
        public function setup_photo_caption_popup(message:String, success:Function):void{
            var share:* = undefined;
            share = function (_arg1:MouseEvent):void{
                remove_pop_up(_arg1);
                success(popup.message_txt.text);
            };
            this.popup.message_txt.text = message;
            this.popup.stage.focus = this.popup.message_txt;
            var l:int = this.popup.message_txt.text.length;
            this.popup.message_txt.setSelection(l, l);
            this.popup.share_btn.buttonMode = true;
            this.popup.share_btn.addEventListener(MouseEvent.CLICK, share);
        }
        public function setup_photo_caption_look(message:String, success:Function):void{
            var share:* = undefined;
            share = function (_arg1:MouseEvent):void{
                remove_pop_up(_arg1);
                success(message);
            };
            Tracer.out("setup_photo_caption_look");
            this.popup.share_btn.buttonMode = true;
            this.popup.share_btn.addEventListener(MouseEvent.CLICK, share);
        }
        public function setup_photo_caption_my_boutique(message:String, success:Function):void{
            var share:* = undefined;
            share = function (_arg1:MouseEvent):void{
                remove_pop_up(_arg1);
                success(message);
            };
            this.popup.share_btn.buttonMode = true;
            this.popup.share_btn.addEventListener(MouseEvent.CLICK, share);
        }
        public function setup_photo_caption_runway(_arg1:String, _arg2:Function):void{
            this.setup_photo_caption_popup(_arg1, _arg2);
        }
        public function setup_photo_caption_user_boutique(message:String, success:Function):void{
            var share:* = undefined;
            share = function (_arg1:MouseEvent):void{
                remove_pop_up(_arg1);
                success(message);
            };
            this.popup.share_btn.buttonMode = true;
            this.popup.share_btn.addEventListener(MouseEvent.CLICK, share);
        }
        public function setup_publish_look_confirm():void{
            var open_appssavvy:* = undefined;
            open_appssavvy = function (_arg1:MouseEvent):void{
                External.showAppssavvy(External.AS_SHARE_WALL);
            };
            this.popup.ok_btn.buttonMode = true;
            this.popup.ok_btn.addEventListener(MouseEvent.CLICK, this.remove_pop_up);
            this.popup.ok_btn.addEventListener(MouseEvent.CLICK, open_appssavvy, false, 0, true);
            this.popup.close_mc.addEventListener(MouseEvent.CLICK, open_appssavvy, false, 0, true);
        }
        public function setup_reset_my_boutique_confirm(callback:Function):void{
            var do_callback:* = undefined;
            do_callback = function (_arg1:MouseEvent):void{
                remove_pop_up(_arg1);
                callback();
            };
            this.popup.continue_mc.buttonMode = true;
            this.popup.continue_mc.addEventListener(MouseEvent.CLICK, do_callback);
            this.popup.skip_mc.buttonMode = true;
            this.popup.skip_mc.addEventListener(MouseEvent.CLICK, this.remove_pop_up, false, 0, true);
        }
        public function setup_select_model(first_model:UserBoutiqueModel, second_model:UserBoutiqueModel, func1:Function, func2:Function, func3:Function):void{
            var click_fashion_show:* = undefined;
            var click_my_boutique:* = undefined;
            var click_add_model:* = undefined;
            var show_highlight:* = undefined;
            var hide_highlight:* = undefined;
            click_fashion_show = function (_arg1=null){
                remove_pop_up(_arg1);
                func1();
            };
            click_my_boutique = function (_arg1=null){
                remove_pop_up(_arg1);
                func2();
            };
            click_add_model = function (_arg1=null){
                remove_pop_up(_arg1);
                func3();
            };
            show_highlight = function (_arg1=null){
                var _local2:int = MovieClip(_arg1.currentTarget).hnum;
                popup[("highlight" + _local2)].visible = true;
            };
            hide_highlight = function (_arg1=null){
                var _local2:int = MovieClip(_arg1.currentTarget).hnum;
                popup[("highlight" + _local2)].visible = false;
            };
            this.popup.highlight1.visible = false;
            this.popup.highlight2.visible = false;
            this.popup.highlight3.visible = false;
            this.popup.fashion_show_btn.buttonMode = true;
            this.popup.fashion_show_btn.hnum = 1;
            this.popup.fashion_show_btn.addEventListener(MouseEvent.CLICK, click_fashion_show);
            this.popup.fashion_show_btn.addEventListener(MouseEvent.ROLL_OVER, show_highlight, false, 0, true);
            this.popup.fashion_show_btn.addEventListener(MouseEvent.ROLL_OUT, hide_highlight, false, 0, true);
            this.popup.my_boutique_btn.buttonMode = true;
            this.popup.my_boutique_btn.hnum = 2;
            this.popup.my_boutique_btn.addEventListener(MouseEvent.CLICK, click_my_boutique);
            this.popup.my_boutique_btn.addEventListener(MouseEvent.ROLL_OVER, show_highlight, false, 0, true);
            this.popup.my_boutique_btn.addEventListener(MouseEvent.ROLL_OUT, hide_highlight, false, 0, true);
            this.popup.add_model_btn.buttonMode = true;
            this.popup.add_model_btn.hnum = 3;
            this.popup.add_model_btn.addEventListener(MouseEvent.CLICK, click_add_model);
            this.popup.add_model_btn.addEventListener(MouseEvent.ROLL_OVER, show_highlight, false, 0, true);
            this.popup.add_model_btn.addEventListener(MouseEvent.ROLL_OUT, hide_highlight, false, 0, true);
            var scale:Number = 0.65;
            this.popup.container1.scaleX = scale;
            this.popup.container1.scaleY = scale;
            this.popup.container2.scaleX = scale;
            this.popup.container2.scaleY = scale;
            this.popup.container3.scaleX = scale;
            this.popup.container3.scaleY = scale;
            var mw:ModelWrapper = new ModelWrapper(DressingRoom.user_default_clothing, DressingRoom.user_default_styles, this.popup.container1);
            if (second_model)
            {
                if (first_model.placed == false)
                {
                    mw = new ModelWrapper(second_model.items, second_model.style_obj, this.popup.container2);
                    mw = new ModelWrapper(first_model.items, first_model.style_obj, this.popup.container3);
                    this.popup.secondModelBtn.visible = false;
                } else
                {
                    mw = new ModelWrapper(first_model.items, first_model.style_obj, this.popup.container2);
                    mw = new ModelWrapper(second_model.items, second_model.style_obj, this.popup.container3);
                    if (!second_model.placed)
                    {
                        this.popup.secondModelBtn.visible = false;
                    };
                };
            } else
            {
                mw = new ModelWrapper(first_model.items, first_model.style_obj, this.popup.container2);
                mw = new ModelWrapper(DressingRoom.get_default_clothing(), new Styles(), this.popup.container3);
                this.popup.firstModelBtn.visible = false;
                this.popup.secondModelBtn.visible = false;
            };
        }
        public function setup_three_day_reward():void{
            var _local1:int = UserData.getInstance().three_day_reward_days;
            this.popup.bg.gotoAndStop(_local1);
            this.popup.text.gotoAndStop(_local1);
            this.popup.ok_btn.buttonMode = true;
            this.popup.ok_btn.addEventListener(MouseEvent.CLICK, this.remove_pop_up);
            if (_local1 == 3)
            {
                PelletFactory.make_cash_pellet(Constants.THREE_DAY_REWARD);
                SoundEffectManager.getInstance().play_sound("Chime.mp3", 0.75);
            };
        }
        public function setup_vote_limit():void{
            var back_to_city:* = undefined;
            var buy_vote:* = undefined;
            back_to_city = function (_arg1:MouseEvent):void{
                remove_pop_up(_arg1);
                Main.getInstance().set_section(Constants.SECTION_CITY);
            };
            buy_vote = function (_arg1:MouseEvent):void{
                remove_pop_up(_arg1);
                DataManager.getInstance().buy_vote();
            };
            this.popup.return_mc.buttonMode = true;
            this.popup.return_mc.addEventListener(MouseEvent.CLICK, back_to_city);
            this.popup.continue_voting.buttonMode = true;
            this.popup.continue_voting.addEventListener(MouseEvent.CLICK, buy_vote);
        }
        public function setup_weekly_challenge(_arg1:String):void{
            this.popup.txt.embedFonts = true;
            var _local2:TextFormat = new TextFormat();
            var _local3:Font = (MainViewController.getInstance().get_game_asset("arial_narrow_bold") as Font);
            _local2.font = _local3.fontName;
            _local2.bold = true;
            this.popup.txt.defaultTextFormat = _local2;
            this.popup.txt.text = _arg1;
            Util.verticallyCenterText(this.popup.txt);
        }
        public function display_insufficient_level():void{
            var _local1:int = (Constants.PARIS_POINTS - UserData.getInstance().points);
            var _local2:String = (((_local1)==1) ? "1 point" : (_local1 + " points"));
            var _local3 = (("Oops, you need " + _local2) + " to get to the level required to buy this item. You're almost there!");
            this.display_popup(ALERT, _local3);
        }
        public function display_restore_frame_rate():void{
            this.display_popup(ALERT, "To save energy, we've paused your game.  Please click OK to return to it!");
            this.popup.close_mc.addEventListener(MouseEvent.CLICK, this.restore_frame_rate);
            this.popup.ok_mc.addEventListener(MouseEvent.CLICK, this.restore_frame_rate);
        }

    }
}//package com.viroxoty.fashionista

