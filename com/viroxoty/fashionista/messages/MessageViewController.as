// Decompiled by AS3 Sorcerer 1.78
// http://www.as3sorcerer.com/

//com.viroxoty.fashionista.messages.MessageViewController

package com.viroxoty.fashionista.messages{
    import flash.text.TextFormat;
    import flash.display.MovieClip;
    import com.viroxoty.fashionista.asset.AssetDataObject;
    import flash.display.DisplayObject;
    import flash.events.MouseEvent;
    import com.viroxoty.fashionista.*;
    import flash.events.*;
    import flash.text.*;
    import com.viroxoty.fashionista.asset.*;
    import com.viroxoty.fashionista.main.*;
    import com.viroxoty.fashionista.util.*;

    public class MessageViewController {

        public static const TYPE_A_LIST_ADD:String = "a_list_add";
        public static const TYPE_BOUTIQUE_EARNINGS:String = "boutique_earnings";
        public static const TYPE_DAILY_DEAL:String = "daily_deal";
        public static const TYPE_DAILY_FREE_ITEM:String = "daily_free_item";
        public static const TYPE_DECOR_GIFT:String = "decor_gift";
        public static const TYPE_DECOR_REQUEST:String = "decor_request";
        public static const TYPE_FRIEND_GREETING:String = "friend_greeting";
        public static const TYPE_FRIEND_JOINED:String = "friend_joined";
        public static const TYPE_FRIEND_DECOR_PURCHASE:String = "friend_decor_purchase";
        public static const TYPE_FRIEND_PURCHASE:String = "friend_purchase";
        public static const TYPE_FREE_ITEM:String = "free_item";
        public static const TYPE_FREE_ITEM_REQUEST:String = "free_item_request";
        public static const TYPE_GIFT:String = "gift";
        public static const TYPE_ITEM_GIFT:String = "item_gift";
        public static const TYPE_ITEM_REQUEST:String = "item_request";
        public static const TYPE_JOIN_TEAM:String = "join_team";
        public static const TYPE_JOINED_TEAM:String = "joined_team";
        public static const TYPE_LAUNCH_BOUTIQUE:String = "launch_boutique";
        public static const TYPE_PLAIN_MESSAGE:String = "plain_message";
        public static const TYPE_PERFUME_GIFT:String = "perfume_gift";
        public static const TYPE_FASHION_EARNINGS:String = "fashion_earnings";
        public static const TYPE_THANK_YOU_GIFT:String = "thank_you_gift";
        public static const decor_types:Array = [TYPE_DECOR_GIFT, TYPE_DECOR_REQUEST, TYPE_FRIEND_DECOR_PURCHASE, TYPE_GIFT, TYPE_PERFUME_GIFT, TYPE_THANK_YOU_GIFT];

        static var tf:TextFormat;
        static var item_name:String;
        static var has_item:Boolean = true;

        public var view:MovieClip;
        public var data:MessageDataObject;
        var sending_ol:MovieClip;

        public function MessageViewController(){
            if (tf == null)
            {
                tf = new TextFormat();
                tf.font = "Arial";
                tf.bold = true;
            };
        }
        public static function make_message(_arg1:MessageDataObject):MovieClip{
            var _local2:Class;
            var _local3:MovieClip;
            var _local4:MessageViewController;
            var _local5:int;
            Tracer.out(("make_message: " + _arg1.type));
            _local4 = new (MessageViewController)();
            _local4.data = _arg1;
            var _local6:String = _arg1.type;
            if (_local6 == TYPE_FRIEND_DECOR_PURCHASE)
            {
                _local6 = TYPE_FRIEND_PURCHASE;
            } else
            {
                if (_local6 == TYPE_DECOR_REQUEST)
                {
                    _local6 = TYPE_ITEM_REQUEST;
                } else
                {
                    if (_local6 == TYPE_DECOR_GIFT)
                    {
                        _local6 = TYPE_FREE_ITEM;
                    } else
                    {
                        if (_local6 == TYPE_ITEM_GIFT)
                        {
                            _local6 = TYPE_FREE_ITEM;
                        };
                    };
                };
            };
            _local2 = MessageCenter.getInstance().class_by_name(_local6);
            _local3 = new (_local2)();
            _local4.view = _local3;
            if (_arg1.item)
            {
                item_name = _arg1.item.name;
            };
            has_item = true;
            switch (_arg1.type)
            {
                case TYPE_A_LIST_ADD:
                    if (UserData.getInstance().check_a_list(_arg1.sender))
                    {
                        _arg1.text = _arg1.text.split(", please add me to yours!").join("!");
                        item_name = "Accept FashionCash reward";
                        _arg1.itemPng = (Constants.SERVER_IMAGES + "a_list.png");
                        _local3.add_btn.buttonMode = true;
                        _local3.add_btn.addEventListener(MouseEvent.CLICK, _local4.accept_a_list_reward);
                    } else
                    {
                        item_name = "Accept FashionCash reward and add them to your A-List";
                        _arg1.itemPng = (Constants.SERVER_IMAGES + "a_list.png");
                        _local3.add_btn.buttonMode = true;
                        _local3.add_btn.addEventListener(MouseEvent.CLICK, _local4.add_to_a_list);
                        _local3.sender_pic.buttonMode = true;
                        _local3.sender_pic.addEventListener(MouseEvent.CLICK, _local4.show_looks);
                        Util.create_tooltip("PREVIEW THEIR LOOKS!", MainViewController.getInstance().tip_container, "left", "top", _local3.sender_pic);
                    };
                    break;
                case TYPE_BOUTIQUE_EARNINGS:
                    _local3.accept_btn.buttonMode = true;
                    _local3.accept_btn.addEventListener(MouseEvent.CLICK, _local4.get_boutique_earnings);
                    has_item = false;
                    break;
                case TYPE_DAILY_DEAL:
                    _local3.buy_btn.buttonMode = true;
                    _local3.buy_btn.addEventListener(MouseEvent.CLICK, _local4.buy_daily_deal);
                    break;
                case TYPE_DAILY_FREE_ITEM:
                    _local3.accept_btn.buttonMode = true;
                    _local3.accept_btn.addEventListener(MouseEvent.CLICK, _local4.accept_daily_free_item);
                    break;
                case TYPE_DECOR_REQUEST:
                case TYPE_ITEM_REQUEST:
                    _local3.buy_btn.buttonMode = true;
                    _local3.buy_btn.addEventListener(MouseEvent.CLICK, _local4.buy_item_for_friend);
                    break;
                case TYPE_DECOR_GIFT:
                case TYPE_ITEM_GIFT:
                case TYPE_FREE_ITEM:
                    _local3.accept_btn.buttonMode = true;
                    _local3.accept_btn.addEventListener(MouseEvent.CLICK, _local4.accept_gift);
                    break;
                case TYPE_FREE_ITEM_REQUEST:
                    _local3.give_btn.buttonMode = true;
                    _local3.give_btn.addEventListener(MouseEvent.CLICK, _local4.give_item);
                    break;
                case TYPE_FRIEND_GREETING:
                    _local3.share_heart_btn.buttonMode = true;
                    _local3.share_heart_btn.addEventListener(MouseEvent.CLICK, _local4.share_heart);
                    item_name = "Jeweled Heart";
                    _arg1.itemPng = (Constants.SERVER_IMAGES + "jewelheart.png");
                    break;
                case TYPE_FRIEND_JOINED:
                    _local3.greet_btn.buttonMode = true;
                    _local3.greet_btn.addEventListener(MouseEvent.CLICK, _local4.greet_friend);
                    item_name = "";
                    _arg1.itemPng = (Constants.SERVER_IMAGES + "jewelheart.png");
                    break;
                case TYPE_FRIEND_DECOR_PURCHASE:
                case TYPE_FRIEND_PURCHASE:
                    _local3.accept_btn.buttonMode = true;
                    _local3.accept_btn.addEventListener(MouseEvent.CLICK, _local4.accept_gift);
                    break;
                case TYPE_PERFUME_GIFT:
                    _local3.thanks_btn.buttonMode = true;
                    _local3.thanks_btn.addEventListener(MouseEvent.CLICK, _local4.send_thank_you_perfume_gift);
                    break;
                case TYPE_JOIN_TEAM:
                    _local3.join_btn.buttonMode = true;
                    _local3.join_btn.addEventListener(MouseEvent.CLICK, _local4.join_team);
                    has_item = false;
                    break;
                case TYPE_JOINED_TEAM:
                    _local3.share_btn.buttonMode = true;
                    _local3.share_btn.addEventListener(MouseEvent.CLICK, _local4.share_join);
                    _arg1.team = DataManager.getInstance().get_team_by_id(int(_arg1.text));
                    _arg1.text = (("Congratulations, you've joined " + _arg1.team.name) + "!");
                    _arg1.sender_name = "Joel Goodrich";
                    _arg1.sender_pic = (Constants.SERVER_IMAGES + "joel.png");
                    item_name = "Tell your friends";
                    _arg1.itemPng = _arg1.team.icon_url;
                    break;
                case TYPE_LAUNCH_BOUTIQUE:
                    Util.simpleButton(_local3.launch_btn, _local4.launch_boutique);
                    has_item = false;
                    break;
                case TYPE_PLAIN_MESSAGE:
                    has_item = false;
                    break;
                case TYPE_FASHION_EARNINGS:
                    has_item = false;
                    _local3.okay_btn.buttonMode = true;
                    _local3.okay_btn.addEventListener(MouseEvent.CLICK, _local4.delete_message);
                    break;
                case TYPE_THANK_YOU_GIFT:
                    _local3.accept_btn.buttonMode = true;
                    _local3.accept_btn.addEventListener(MouseEvent.CLICK, _local4.accept_gift);
                    break;
                default:
                    Tracer.out(("MessageCenter > error: unrecognized message type = " + _arg1.type));
                    return (null);
            };
            _arg1.view = _local3;
            if (_arg1.sender_name)
            {
                _local3.name_txt.text = _arg1.sender_name;
            };
            var _local7:AssetDataObject = new AssetDataObject();
            var _local8:String = _arg1.sender_pic;
            _local7.parseURL(_local8);
            AssetManager.getInstance().getAssetFor(_local7, {"assetLoaded":_local4.sender_pic_loaded});
            _local3.message_txt.defaultTextFormat = tf;
            _local3.message_txt.text = _arg1.text;
            Tracer.out(("has_item = " + has_item));
            if (has_item)
            {
                _local3.item_name_txt.defaultTextFormat = tf;
                _local3.item_name_txt.text = item_name;
                _local7 = new AssetDataObject();
                _local8 = _arg1.itemPng;
                if (_local8.indexOf("c.52.png") > -1)
                {
                    _local8 = _local8.split("c.52.png").join("c52.png");
                };
                _local7.parseURL(_local8);
                AssetManager.getInstance().getAssetFor(_local7, {"assetLoaded":_local4.item_pic_loaded});
            };
            _local3.delete_btn.buttonMode = true;
            _local3.delete_btn.addEventListener(MouseEvent.CLICK, _local4.delete_message);
            return (_local3);
        }

        public function sender_pic_loaded(_arg1:DisplayObject, _arg2:String):void{
            Util.scaleAndCenterDisplayObject(_arg1, 50, 50);
            this.view.sender_pic.addChild(_arg1);
        }
        public function item_pic_loaded(_arg1:DisplayObject, _arg2:String):void{
            Util.scaleAndCenterDisplayObject(_arg1, 50, 50);
            this.view.item_pic.addChild(_arg1);
        }
        public function delete_message(_arg1:MouseEvent):void{
            Tracer.out("MessageViewController > delete_message");
            if (this.data.client_generated == false)
            {
                DataManager.getInstance().delete_messages(String(this.data.id));
            } else
            {
                if (this.data.type == TYPE_DAILY_DEAL)
                {
                    Tracker.deleted_message_daily_deal = true;
                } else
                {
                    if (this.data.type == TYPE_JOIN_TEAM)
                    {
                        Tracker.deleted_message_join_team = true;
                    } else
                    {
                        if ((((this.data.type == TYPE_BOUTIQUE_EARNINGS)) || ((this.data.type == TYPE_LAUNCH_BOUTIQUE))))
                        {
                            Tracker.deleted_message_boutique = true;
                        } else
                        {
                            if (this.data.type == TYPE_FASHION_EARNINGS)
                            {
                                Tracker.deleted_message_fashion_earnings = true;
                            } else
                            {
                                if (this.data.type == TYPE_DAILY_FREE_ITEM)
                                {
                                    Tracker.deleted_message_daily_free_item = true;
                                };
                            };
                        };
                    };
                };
            };
            MessageCenter.getInstance().delete_message(this);
            if (this.sending_ol)
            {
                this.view.removeChild(this.sending_ol);
            };
        }
        public function send_thank_you_perfume_gift(_arg1:MouseEvent):void{
            Tracer.out("MessageViewController > send_thank_you_perfume_gift");
            var _local2:Class = MessageCenter.getInstance().class_by_name("sending_ol");
            this.sending_ol = new (_local2)();
            this.view.addChild(this.sending_ol);
            DataManager.getInstance().send_thank_you_gift(this.data.sender, this.data.item.id, this.send_thanks_complete, this.send_thanks_fail);
        }
        public function send_thanks_complete():void{
            DataManager.getInstance().delete_messages(String(this.data.id));
            MessageCenter.getInstance().delete_message(this);
        }
        public function send_thanks_fail():void{
            this.view.removeChild(this.sending_ol);
        }
        public function accept_gift(_arg1:MouseEvent):void{
            DataManager.getInstance().accept_gift(String(this.data.id), this.data.item);
            MessageCenter.getInstance().delete_message(this);
        }
        public function buy_item_for_friend(_arg1:MouseEvent):void{
            var _local2:Class = MessageCenter.getInstance().class_by_name("sending_ol");
            this.sending_ol = new (_local2)();
            this.view.addChild(this.sending_ol);
            Pop_Up.getInstance().display_popup(Pop_Up.FRIEND_MESSAGE_BUY, this.data.sender, this.data.item, this.data.itemPng, this.buy_item_complete, this.buy_item_fail);
        }
        public function buy_item_complete():void{
            DataManager.getInstance().delete_messages(String(this.data.id));
            MessageCenter.getInstance().delete_message(this);
        }
        public function buy_item_fail():void{
            Tracer.out("Buy item fail");
            if (this.sending_ol)
            {
                this.view.removeChild(this.sending_ol);
            };
        }
        public function give_item(_arg1:MouseEvent):void{
            var _local2:Class = MessageCenter.getInstance().class_by_name("sending_ol");
            this.sending_ol = new (_local2)();
            this.view.addChild(this.sending_ol);
            DataManager.getInstance().give_to_friend(this.data.sender, this.data.item.id, this.give_item_complete, this.give_item_fail);
        }
        public function give_item_complete():void{
            DataManager.getInstance().delete_messages(String(this.data.id));
            MessageCenter.getInstance().delete_message(this);
        }
        public function give_item_fail():void{
            Tracer.out("Give item fail");
            if (this.sending_ol)
            {
                this.view.removeChild(this.sending_ol);
            };
        }
        public function add_to_a_list(_arg1:MouseEvent):void{
            if (UserData.getInstance().check_a_list(this.data.sender))
            {
                DataManager.getInstance().delete_messages(String(this.data.id));
                MessageCenter.getInstance().delete_message(this);
                return;
            };
            var _local2:Class = MessageCenter.getInstance().class_by_name("sending_ol");
            this.sending_ol = new (_local2)();
            this.view.addChild(this.sending_ol);
            DataManager.getInstance().accept_a_list_invite(this.data.sender, this.data.sender_name, this.add_a_list_complete, this.add_a_list_fail);
        }
        public function add_a_list_complete():void{
            if (this.view.contains(this.sending_ol))
            {
                this.view.removeChild(this.sending_ol);
            };
            DataManager.getInstance().delete_messages(String(this.data.id));
            MessageCenter.getInstance().delete_message(this);
            MessageCenter.getInstance().update_a_list();
        }
        public function add_a_list_fail():void{
            if (this.view.contains(this.sending_ol))
            {
                this.view.removeChild(this.sending_ol);
            };
        }
        public function accept_a_list_reward(_arg1:MouseEvent):void{
            Tracer.out("accept_a_list_reward");
            if (UserData.getInstance().check_a_lists_on(this.data.sender))
            {
                DataManager.getInstance().delete_messages(String(this.data.id));
                MessageCenter.getInstance().delete_message(this);
                return;
            };
            var _local2:Class = MessageCenter.getInstance().class_by_name("sending_ol");
            this.sending_ol = new (_local2)();
            this.view.addChild(this.sending_ol);
            DataManager.getInstance().accept_a_list_reward(this.data.sender, this.accept_a_list_reward_complete, this.accept_a_list_reward_fail);
        }
        public function accept_a_list_reward_complete():void{
            if (this.view.contains(this.sending_ol))
            {
                this.view.removeChild(this.sending_ol);
            };
            DataManager.getInstance().delete_messages(String(this.data.id));
            MessageCenter.getInstance().delete_message(this);
        }
        public function accept_a_list_reward_fail():void{
            if (this.view.contains(this.sending_ol))
            {
                this.view.removeChild(this.sending_ol);
            };
        }
        public function greet_friend(_arg1:MouseEvent):void{
            DataManager.getInstance().greet_friend(this.data.id);
            MessageCenter.getInstance().delete_message(this);
        }
        public function share_heart(_arg1:MouseEvent):void{
            FacebookConnector.share_heart(this.data.itemPng);
            DataManager.getInstance().delete_messages(String(this.data.id));
            MessageCenter.getInstance().delete_message(this);
        }
        public function show_looks(_arg1:MouseEvent):void{
            Tracer.out(("show_looks for " + this.data.sender_name));
            MainViewController.getInstance().show_preloader();
            DataManager.getInstance().get_a_lister_looks_xml(this.data.sender, this.set_a_lister_looks_xml);
        }
        public function set_a_lister_looks_xml(_arg1:XML):void{
            var _local2:int = _arg1.children().length();
            Tracer.out(("MessageViewController > set_a_lister_looks_xml : count = " + _local2));
            MainViewController.getInstance().hide_preloader();
            if (_local2 == 0)
            {
                Pop_Up.getInstance().alert((this.data.sender_name + " hasn't entered any looks in this week's challenge yet!"));
                return;
            };
            MessageCenter.getInstance().close();
            Runway.getInstance().a_lister_xml = _arg1;
            if (Main.getInstance().current_section != "runway")
            {
                Runway.getInstance().load(Runway.A_LISTER_PREVIEW);
            } else
            {
                Runway.getInstance().show_a_lister_looks();
            };
        }
        public function buy_daily_deal(_arg1:MouseEvent):void{
            FacebookConnector.buy_daily_deal_item(this.data.item.id, this.buy_daily_deal_success);
        }
        public function buy_daily_deal_success():void{
            this.delete_message(null);
        }
        public function accept_daily_free_item(_arg1:MouseEvent):void{
            MainViewController.getInstance().open_free_item_popup();
            this.delete_message(null);
        }
        public function join_team(_arg1:MouseEvent):void{
            MessageCenter.getInstance().show_team();
            this.delete_message(null);
        }
        public function share_join(_arg1:MouseEvent):void{
            FacebookConnector.share_team(this.data.team.name, this.data.team.large_url);
            this.delete_message(null);
        }
        public function get_boutique_earnings(_arg1:MouseEvent):void{
            Tracer.out("get_boutique_earnings");
            var _local2:Class = MessageCenter.getInstance().class_by_name("sending_ol");
            this.sending_ol = new (_local2)();
            this.view.addChild(this.sending_ol);
            UserData.getInstance().pending_fcash_reward = UserData.getInstance().boutique_earnings;
            DataManager.getInstance().get_boutique_earnings(this.get_boutique_earnings_complete, this.get_boutique_earnings_fail);
        }
        public function get_boutique_earnings_complete():void{
            if (this.view.contains(this.sending_ol))
            {
                this.view.removeChild(this.sending_ol);
            };
            DataManager.getInstance().delete_messages(String(this.data.id));
            MessageCenter.getInstance().delete_message(this);
        }
        public function get_boutique_earnings_fail():void{
            UserData.getInstance().pending_fcash_reward = 0;
            if (this.view.contains(this.sending_ol))
            {
                this.view.removeChild(this.sending_ol);
            };
        }
        public function launch_boutique(_arg1:MouseEvent):void{
            Tracer.out("get_boutique_earnings");
            var _local2:Class = MessageCenter.getInstance().class_by_name("sending_ol");
            this.sending_ol = new (_local2)();
            this.view.addChild(this.sending_ol);
            DataManager.getInstance().set_boutique_active(this.launch_boutique_complete, this.launch_boutique_fail);
        }
        public function launch_boutique_complete(){
            if (this.view.contains(this.sending_ol))
            {
                this.view.removeChild(this.sending_ol);
            };
            DataManager.getInstance().delete_messages(String(this.data.id));
            MessageCenter.getInstance().delete_message(this);
        }
        public function launch_boutique_fail(){
            if (this.view.contains(this.sending_ol))
            {
                this.view.removeChild(this.sending_ol);
            };
        }

    }
}//package com.viroxoty.fashionista.messages

