// Decompiled by AS3 Sorcerer 1.78
// http://www.as3sorcerer.com/

//com.viroxoty.fashionista.UserData

package com.viroxoty.fashionista{
    import __AS3__.vec.Vector;
    import com.viroxoty.fashionista.data.Friend;
    import com.viroxoty.fashionista.data.Team;
    import com.viroxoty.fashionista.data.UserBoutique;
    import com.viroxoty.fashionista.data.Album;
    import com.viroxoty.fashionista.data.PurchasableObject;
    import flash.utils.Timer;
    import com.viroxoty.fashionista.data.Item;
    import com.viroxoty.fashionista.data.Styles;
    import flash.events.Event;
    import com.viroxoty.fashionista.data.Decor;
    import com.viroxoty.fashionista.data.UserDecor;
    import com.viroxoty.fashionista.data.*;
    import flash.events.*;
    import __AS3__.vec.*;
    import flash.utils.*;
    import flash.text.*;
    import com.viroxoty.fashionista.ui.*;
    import flash.display.*;
    import com.viroxoty.fashionista.user_boutique.*;
    import com.viroxoty.fashionista.sound.*;
    import com.adobe.serialization.json.*;
    import com.viroxoty.fashionista.main.*;
    import com.viroxoty.fashionista.util.*;

    public class UserData {

        private static var _instance:UserData;
        static var CASH_MILLISECONDS:int = 15000;
        static var CASH_POLLS:int = 6;

        public var user_name:String;
        public var first_name:String;
        public var uid:int;
        public var third_party_id:String;
        public var ip_address:String;
        public var country_code:String;
        public var level:int;
        var actual_level:int;
        public var mini_level:int;
        public var actual_mini_level:int;
        public var points:int;
        var actual_points:int;
        public var fcash:int;
        var actual_fcash:int;
        var vip_points:int;
        public var week_votes:int;
        public var day_votes:int;
        public var closet:Array;
        public var friends:Vector.<Friend>;
        public var app_friends:Vector.<Friend>;
        public var lookup_app_friends:Object;
        public var non_app_friends:Vector.<Friend>;
        public var a_list_ids:Object;
        public var a_list:Vector.<Friend>;
        public var a_list_active_boutique:Vector.<Friend>;
        public var a_lists_on:Array;
        public var team:Team;
        public var prev_team:int;
        public var last_avatar_id:int;
        public var boutique:UserBoutique;
        public var has_boutique:Boolean;
        public var has_active_boutique:Boolean;
        public var boutique_earnings:int;
        public var decor_inventory:Object;
        public var albums:Vector.<Album>;
        public var album_lookup:Object;
        public var pending_fcash_reward:int;
        public var pending_points_reward:int;
        public var pending_purchase:PurchasableObject;
        public var pending_points_purchase:Boolean;
        public var visits:int;
        public var visits_today:int = 0;
        public var three_day_reward_days:int = 1;
        public var didGetBestDressed:Boolean = false;
        public var daily_free_request:Boolean = false;
        public var daily_free_give:Boolean = false;
        public var daily_gift_center:Boolean = false;
        public var daily_sponsored_item:Boolean = false;
        public var visited_city:int = 0;
        public var offline_data:Object;
        public var offline_leveling_reward:int;
        public var paris_welcome:Boolean;
        public var leveling_welcome:Boolean;
        public var shopping_welcome:Boolean;
        public var show_tutorial_end:Boolean;
        public var birthday_flag:Boolean;
        public var check_free_item:Boolean = false;
        public var has_pr_agent:Boolean;
        public var can_change_team:Boolean;
        public var first_vote:Boolean = false;
        public var first_item:Boolean = false;
        public var first_faceoff_won:Boolean = false;
        public var new_to_faceoff:Boolean = false;
        public var show_like_button:Boolean;
        private var cashTimer:Timer;
        private var isPolling:Boolean;
        private var curCoins:int;

        public function UserData(){
            this.a_lists_on = [];
            this.decor_inventory = {};
            super();
            _instance = this;
            Tracer.out("new UserData");
            this.cashTimer = new Timer(CASH_MILLISECONDS, CASH_POLLS);
            this.cashTimer.addEventListener(TimerEvent.TIMER, this.checkBalances, false, 0, true);
        }
        public static function getInstance():UserData{
            if (_instance == null)
            {
                _instance = new (UserData)();
            };
            return (_instance);
        }

        public function set_visits(_arg1:int):void{
            this.visits = _arg1;
            this.shopping_welcome = this.first_time_visit();
        }
        public function processStartupData(_arg1:Object){
            var _local2:Array;
            var _local3:int;
            var _local4:int;
            var _local5:Item;
            var _local6:Vector.<Item>;
            var _local7:Item;
            var _local8:Vector.<Item>;
            var _local9:Styles;
            var _local10:Object;
            var _local11:int;
            Tracer.out(("processStartupData: o is " + _arg1));
            this.user_name = _arg1.name;
            this.first_name = _arg1.first_name;
            this.uid = int(_arg1.id);
            this.ip_address = _arg1.ip_address;
            this.third_party_id = _arg1.third_party_id;
            this.country_code = _arg1.country;
            External.init();
            this.level = int(_arg1.level);
            this.actual_level = this.level;
            this.mini_level = int(_arg1.mini_level);
            this.actual_mini_level = this.mini_level;
            this.points = int(_arg1.points);
            this.fcash = int(_arg1.coins);
            this.actual_points = this.points;
            this.actual_fcash = this.fcash;
            this.vip_points = _arg1.vip_points;
            this.week_votes = _arg1.votes;
            this.day_votes = _arg1.dayVotes;
            this.has_boutique = _arg1.hasBoutique;
            if ((((this.has_boutique == false)) || ((this.visits == 2))))
            {
                Tracker.set_my_boutique_flags();
            };
            this.has_active_boutique = (_arg1.hasActiveBoutique == "1");
            this.boutique_earnings = _arg1.boutiqueEarnings;
            if (_arg1.team)
            {
                this.team = DataManager.getInstance().get_team_by_id(_arg1.team);
            } else
            {
                Tracer.out("user is not on a team");
            };
            this.can_change_team = _arg1.canChangeTeam;
            this.prev_team = _arg1.prev_team;
            this.set_visits(_arg1.visits);
            this.has_pr_agent = (_arg1.has_pr_agent == 1);
            this.show_like_button = !((_arg1.like_button_shown == 1));
            this.set_albums(_arg1.albums);
            CleanupController.total_jewels = (CleanupController.total_jewels - _arg1.cleanupRewards);
            this.closet = [];
            if (_arg1.closet)
            {
                Tracer.out(("o.closet is " + getQualifiedClassName(_arg1.closet)));
                _local2 = Json.decode(_arg1.closet);
                _local3 = _local2.length;
                if (_local3 > 0)
                {
                    _local4 = 0;
                    while (_local4 < _local3)
                    {
                        _local5 = new Item();
                        if (_local5.parseServerItem(_local2[_local4]))
                        {
                            this.closet.push(_local5);
                        };
                        _local4++;
                    };
                };
                Tracer.out((("   user closet has " + this.closet.length) + " items"));
                DressingRoom.sort_closet(this.closet);
            };
            if (_arg1.defaultAvatar)
            {
                Tracer.out("  setting user default avatar");
                _local3 = _arg1.defaultAvatar.items.length;
                if (_local3 > 0)
                {
                    _local6 = new Vector.<Item>();
                    _local8 = new Vector.<Item>();
                    _local4 = 0;
                    while (_local4 < _local3)
                    {
                        _local5 = new Item();
                        _local5.parseServerItem(_arg1.defaultAvatar.items[_local4]);
                        if (_local5.category == "pet_models")
                        {
                            _local7 = _local5;
                        } else
                        {
                            if (_local5.category == "leashes")
                            {
                                _local8.push(_local5);
                            } else
                            {
                                _local6.push(_local5);
                            };
                        };
                        _local4++;
                    };
                    _local9 = Styles.parse_style_string(_arg1.defaultAvatar.style);
                    DressingRoom.set_user_defaults(_local6, _local9, _local7, _local8);
                };
            };
            Tracer.out("  processing tracks");
            if (_arg1.tracks)
            {
                _local3 = _arg1.tracks.length;
                _local4 = 0;
                while (_local4 < _local3)
                {
                    _local10 = _arg1.tracks[_local4];
                    _local11 = int(_local10.count);
                    if ((((_local10.event == "visit")) && ((_local10.target == "paris"))))
                    {
                        this.paris_welcome = (_local11 < 3);
                        Tracer.out((("  user made " + _local11) + " paris visits"));
                    } else
                    {
                        if ((((_local10.event.indexOf("request_free_item") > -1)) && ((_local11 > 0))))
                        {
                            this.daily_free_request = true;
                        } else
                        {
                            if ((((_local10.event.indexOf("give_free_item") > -1)) && ((_local11 > 0))))
                            {
                                this.daily_free_give = true;
                            } else
                            {
                                if ((((_local10.event.indexOf(Tracker.OPEN_GIFT_CENTER) > -1)) && ((_local11 > 0))))
                                {
                                    this.daily_gift_center = true;
                                } else
                                {
                                    if ((((_local10.event == Tracker.SHOPPING_WELCOME)) && ((_local10.target == Tracker.FIRST_TIME))))
                                    {
                                        this.shopping_welcome = (_local11 == 0);
                                        if ((((this.visits > 2)) || ((this.actual_fcash < 2000))))
                                        {
                                            this.shopping_welcome = false;
                                            Tracker.track(Tracker.SHOPPING_WELCOME, Tracker.FIRST_TIME);
                                        };
                                    } else
                                    {
                                        if ((((_local10.event == Tracker.TUTORIAL_END)) && ((_local10.target == Tracker.FIRST_TIME))))
                                        {
                                            this.show_tutorial_end = (_local11 == 0);
                                            if (this.visits > 2)
                                            {
                                                this.show_tutorial_end = false;
                                                Tracker.track(Tracker.TUTORIAL_END, Tracker.FIRST_TIME);
                                            };
                                        } else
                                        {
                                            if ((((_local10.event == Tracker.WIN)) && ((_local10.target == Tracker.FACEOFF))))
                                            {
                                                this.first_faceoff_won = (_local11 > 0);
                                            } else
                                            {
                                                if ((((_local10.event == Tracker.VISIT)) && ((_local10.target == Tracker.FACEOFF))))
                                                {
                                                    this.new_to_faceoff = (_local11 < 3);
                                                };
                                            };
                                        };
                                    };
                                };
                            };
                        };
                    };
                    _local4++;
                };
            };
            if (_arg1.multiDayReward)
            {
                this.three_day_reward_days = _arg1.multiDayReward.consecutiveDays;
                Tracer.out(("  three_day_reward_days = " + this.three_day_reward_days));
                if ((((((this.three_day_reward_days == 3)) && ((_arg1.multiDayReward.receivedReward == false)))) && ((this.visits_today == 1))))
                {
                    this.fcash = (this.fcash - Constants.THREE_DAY_REWARD);
                };
            };
            this.offline_data = _arg1.offline;
            if (!this.first_time_visit())
            {
                Tracer.out("  setting messages");
                MessageCenter.getInstance().set_messages(_arg1.messages);
            };
            Tracer.out("  checking cookies");
            CookieManager.init();
            var _local12:Date = new Date();
            var _local13:int = _local12.month;
            var _local14:int = _local12.date;
            var _local15:int = _local12.fullYear;
            var _local16:String = ((((_local15 + "_") + (_local13 + 1)) + "_") + _local14);
            if (CookieManager.getValue("last_visit") != _local16)
            {
                CookieManager.saveValue("last_visit", _local16);
                this.visits_today = 1;
            } else
            {
                this.visits_today = (CookieManager.getValue("visits_today") + 1);
            };
            CookieManager.saveValue("visits_today", this.visits_today);
            if (Constants.DEV_FRESH_DAILY_VISIT_MODE)
            {
                this.visits_today = 1;
            };
            if ((((CookieManager.getValue("shopping_tip_seen") == true)) && ((this.first_time_visit() == false))))
            {
                this.shopping_welcome = false;
            };
            Tracer.out(("shopping_welcome is " + this.shopping_welcome));
            if (CookieManager.getValue("faceoff_won"))
            {
                this.first_faceoff_won = true;
            };
            var _local17:int = (((CookieManager.getValue("faceoff_visits"))==null) ? 1 : (CookieManager.getValue("faceoff_visits") + 1));
            if (_local17 < 4)
            {
                this.new_to_faceoff = true;
            };
            if (((this.first_time_visit()) || (this.shopping_welcome)))
            {
                this.fcash = (this.fcash - Constants.STARTING_CASH);
            };
            Tracer.out(("UserData > processStartupData complete: fcash = " + this.fcash));
        }
        public function init():void{
            TopMenu.getInstance().display_coins(this.fcash);
            TopMenu.getInstance().display_points_level(this.points, this.level);
            if (((this.leveling_welcome) && ((this.visits > 1))))
            {
                Tracer.out(("visits = " + this.visits));
                Pop_Up.getInstance().display_popup(Pop_Up.LEVEL_UP, true);
            } else
            {
                if (this.offline_leveling_reward > 0)
                {
                    Pop_Up.getInstance().display_popup(Pop_Up.LEVEL_UP);
                };
            };
        }
        public function check_initial_fcash_drop():void{
            Tracer.out("check_initial_fcash_drop");
            if (((this.shopping_welcome) && ((this.visits == 2))))
            {
                this.shopping_welcome = false;
                PelletFactory.make_cash_pellet((Constants.STARTING_CASH / 4), 1.5);
                PelletFactory.make_cash_pellet((Constants.STARTING_CASH / 4), 1.5);
                PelletFactory.make_cash_pellet((Constants.STARTING_CASH / 4), 1.5);
                PelletFactory.make_cash_pellet((Constants.STARTING_CASH / 4), 1.5);
                SoundEffectManager.getInstance().play_pellet_drop();
                if (Tracker.first_time_shopping_welcome == false)
                {
                    (Tracker.first_time_shopping_welcome == true);
                    Tracker.track(Tracker.SHOPPING_WELCOME, Tracker.FIRST_TIME);
                };
            };
        }
        public function add_points(_arg1:int):void{
            Tracer.out(((((("add_points > points = " + this.points) + ", actual_points = ") + this.actual_points) + ", increment = ") + _arg1));
            this.points = Math.min((this.points + _arg1), this.actual_points);
            this.check_level_up();
            this.check_mini_level_up();
            TopMenu.getInstance().display_points_level(this.points, this.level);
        }
        public function add_cash(_arg1:int):void{
            Tracer.out(((((("add_cash > fcash = " + this.fcash) + ", actual_fcash = ") + this.actual_fcash) + ", increment = ") + _arg1));
            this.fcash = Math.min((this.fcash + _arg1), this.actual_fcash);
            TopMenu.getInstance().display_coins(this.fcash);
        }
        public function checkBalances(_arg1:Event):void{
            DataManager.getInstance().check_user_balances();
        }
        public function checked_user_balances(_arg1:int, _arg2:int, _arg3:int, _arg4:int):void{
            var _local5:int;
            var _local6:Number;
            Tracer.out(((((("checked_user_balances > current fcash is " + this.fcash) + ", actual_fcash is ") + this.actual_fcash) + ", pending_fcash_reward is ") + this.pending_fcash_reward));
            this.curCoins = this.fcash;
            var _local7:int = (this.actual_fcash - this.fcash);
            this.fcash = (_arg3 - _local7);
            this.actual_level = _arg2;
            if (this.actual_level > this.level)
            {
                this.fcash = (this.fcash - (Constants.LEVEL_UP_REWARD * (this.actual_level - this.level)));
            };
            if (_arg4 > 0)
            {
                this.actual_mini_level = (this.actual_mini_level + _arg4);
                this.fcash = (this.fcash - (_arg4 * Constants.MINI_LEVEL_REWARD));
                if (this.pending_points_purchase)
                {
                    this.pending_points_purchase = false;
                    _local5 = 0;
                    this.points = _arg1;
                    this.check_mini_level_up();
                    this.check_level_up();
                    TopMenu.getInstance().display_points_level(this.points, this.level);
                } else
                {
                    _local5 = (_arg1 - this.actual_points);
                };
                MiniLevelController.getInstance().set_reward(_arg4, _local5);
                this.pending_points_reward = 0;
            } else
            {
                this.check_level_up();
                if (this.pending_points_reward > 0)
                {
                    this.points = (_arg1 - this.pending_points_reward);
                    PelletFactory.make_points_pellet(this.pending_points_reward);
                    SoundEffectManager.getInstance().play_pellet_drop();
                    this.pending_points_reward = 0;
                } else
                {
                    this.points = _arg1;
                    TopMenu.getInstance().display_points_level(this.points, this.level);
                };
            };
            if (this.pending_fcash_reward > 0)
            {
                _local6 = (((this.pending_fcash_reward)>=500) ? 2 : 1);
                PelletFactory.make_cash_pellet(this.pending_fcash_reward, _local6);
                SoundEffectManager.getInstance().play_pellet_drop();
                this.fcash = (this.fcash - this.pending_fcash_reward);
                this.pending_fcash_reward = 0;
            };
            TopMenu.getInstance().display_coins(this.fcash);
            this.actual_fcash = _arg3;
            this.actual_points = _arg1;
        }
        function check_level_up():void{
            var _local1:int;
            Tracer.out(((("check_level_up > level = " + this.level) + ", actual_level = ") + this.actual_level));
            if (this.level < this.actual_level)
            {
                _local1 = (this.actual_level - this.level);
                this.level = this.actual_level;
                if (this.level != 1)
                {
                    if (this.level == Constants.PARIS_LEVEL)
                    {
                        Pop_Up.getInstance().display_popup(Pop_Up.LEVEL_PARIS);
                    } else
                    {
                        if (this.level == 3)
                        {
                            Pop_Up.getInstance().display_popup(Pop_Up.LEVEL_3);
                        } else
                        {
                            if (this.level == 4)
                            {
                                Pop_Up.getInstance().display_popup(Pop_Up.LEVEL_4);
                            } else
                            {
                                if (this.level == 5)
                                {
                                    Pop_Up.getInstance().display_popup(Pop_Up.LEVEL_5);
                                } else
                                {
                                    if (this.level == 6)
                                    {
                                        Pop_Up.getInstance().display_popup(Pop_Up.LEVEL_6);
                                    } else
                                    {
                                        if (this.level == 7)
                                        {
                                            Pop_Up.getInstance().display_popup(Pop_Up.LEVEL_7);
                                        } else
                                        {
                                            if (this.level == 8)
                                            {
                                                Pop_Up.getInstance().display_popup(Pop_Up.LEVEL_8);
                                            } else
                                            {
                                                if (this.level == 9)
                                                {
                                                    Pop_Up.getInstance().display_popup(Pop_Up.LEVEL_9);
                                                } else
                                                {
                                                    Pop_Up.getInstance().display_popup(Pop_Up.LEVEL_UP);
                                                };
                                            };
                                        };
                                    };
                                };
                            };
                        };
                    };
                };
                Runway.getInstance().user_leveled();
                PelletFactory.make_cash_pellet((Constants.LEVEL_UP_REWARD * _local1));
                SoundEffectManager.getInstance().play_pellet_drop();
            };
        }
        function check_mini_level_up():void{
            var _local1:String;
            if (this.mini_level < this.actual_mini_level)
            {
                this.mini_level = this.actual_mini_level;
                _local1 = Main.getInstance().current_section;
                if ((((((_local1 == Constants.SECTION_BOUTIQUE)) || ((_local1 == Constants.SECTION_BOUTIQUE_VISIT)))) || ((_local1 == Constants.SECTION_MY_BOUTIQUE))))
                {
                    ScrollingDirectoryController.getInstance().update_locks();
                };
            };
        }
        public function pollBalances():void{
            Tracer.out("UserData > pollBalances: starting to poll server to see if fcash has increased by 199 or more");
            this.cashTimer.reset();
            this.cashTimer.start();
            this.isPolling = true;
            this.checkBalances(new Event("checkBalance"));
        }
        public function stopPolling():void{
            this.cashTimer.stop();
            this.isPolling = false;
        }
        public function buy_item(_arg1:Item){
            this.pending_purchase = _arg1;
            if (((this.owns(_arg1)) || ((this.level >= _arg1.level))))
            {
                Pop_Up.getInstance().display_popup(Pop_Up.BUY_ITEM, _arg1);
            } else
            {
                Pop_Up.getInstance().display_popup(Pop_Up.LEVEL_TOO_LOW, "item", _arg1);
            };
        }
        public function do_item_purchase():void{
            var _local1:Main;
            Tracer.out(("UserData > do_item_purchase: pending_purchase is " + this.pending_purchase));
            if (this.pending_purchase)
            {
                if ((this.pending_purchase is Item))
                {
                    this.add_to_closet((this.pending_purchase as Item));
                };
                DataManager.getInstance().check_user_balances();
                _local1 = Main.getInstance();
                if (SnapshotController.getInstance().is_open)
                {
                    SnapshotController.getInstance().purchased_bg((this.pending_purchase as Item));
                } else
                {
                    if (_local1.current_section == Constants.SECTION_BOUTIQUE)
                    {
                        if (_local1.screen_controller.hasOwnProperty("showDressingRoomTip"))
                        {
                            _local1.screen_controller.showDressingRoomTip();
                        };
                    } else
                    {
                        if (ModelUIController.current_instance())
                        {
                            if (DressingRoom.item_is_style((this.pending_purchase as Item)))
                            {
                                ModelUIController.current_instance().style_item_purchased(this.pending_purchase.id);
                            } else
                            {
                                ModelUIController.current_instance().closet_item_purchased((this.pending_purchase as Item));
                            };
                        };
                    };
                };
                this.pending_purchase = null;
            };
        }
        public function cancel_purchase():void{
            this.pending_purchase = null;
        }
        public function do_boutique_floor_purchase():void{
            if (Main.getInstance().current_section == Constants.SECTION_MY_BOUTIQUE)
            {
                MyBoutique.getInstance().add_floor();
            } else
            {
                this.boutique.add_floor();
            };
        }
        public function add_to_closet(_arg1:Item):void{
            var _local2:int;
            Tracer.out(("UserData > add_to_closet: " + _arg1));
            var _local3:int = this.closet.length;
            while (_local2 < _local3)
            {
                if (this.closet[_local2].id == _arg1.id)
                {
                    Tracer.out("UserData > add_to_closet: ERROR item is already in closet");
                    return;
                };
                _local2++;
            };
            this.closet.push(_arg1);
            Tracer.out(("UserData > add_to_closet: total count: " + this.closet.length));
            DressingRoom.sort_item(_arg1);
        }
        public function owns(_arg1:PurchasableObject):Boolean{
            if ((_arg1 is Item))
            {
                return (this.owns_id(_arg1.id));
            };
            return (this.owns_decor_id(_arg1.id));
        }
        public function owns_id(_arg1:int):Boolean{
            var _local2:int;
            var _local3:int = this.closet.length;
            while (_local2 < _local3)
            {
                if (this.closet[_local2].id == _arg1)
                {
                    return (true);
                };
                _local2++;
            };
            return (false);
        }
        public function owns_decor_id(_arg1:int):Boolean{
            return (!((this.decor_inventory[_arg1] == null)));
        }
        public function reward_free_item():void{
            this.daily_sponsored_item = false;
            this.add_to_closet(DataManager.getInstance().free_item);
        }
        public function buy_decor(_arg1:Decor){
            Tracer.out(("UserData > buy_decor: " + _arg1.toString()));
            this.pending_purchase = _arg1;
            if (this.level >= _arg1.level)
            {
                if (_arg1.fb_credits)
                {
                    FacebookConnector.buy_decor(_arg1, this.complete_decor_purchase, this.cancel_purchase);
                } else
                {
                    Pop_Up.getInstance().display_popup(Pop_Up.BUY_ITEM, _arg1);
                };
            } else
            {
                Pop_Up.getInstance().display_popup(Pop_Up.LEVEL_TOO_LOW, "item", _arg1);
            };
        }
        public function complete_decor_purchase(_arg1:Decor, _arg2:int){
            Tracer.out("UserData > complete_decor_purchase");
            var _local3:UserDecor = this.add_to_decor_inventory(_arg1, _arg2);
            var _local4:Main = Main.getInstance();
            if (_local4.current_section == Constants.SECTION_MY_BOUTIQUE)
            {
                MyBoutique.getInstance().handle_decor_purchase(_local3);
            };
            if (this.pending_purchase)
            {
                this.pending_purchase = null;
            };
        }
        public function accept_decor_gift(_arg1:Decor, _arg2:int){
            var _local3:UserDecor = this.add_to_decor_inventory(_arg1, _arg2);
            var _local4:Main = Main.getInstance();
            if (_local4.current_section == Constants.SECTION_MY_BOUTIQUE)
            {
                MyBoutique.getInstance().handle_decor_gift(_local3);
            };
        }
        function add_to_decor_inventory(_arg1:Decor, _arg2:int):UserDecor{
            var _local3:Decor;
            Tracer.out(("UserData > add_to_decor_inventory: " + _arg1));
            var _local4:UserDecor = new UserDecor();
            _local4.id = _arg2;
            if (this.decor_inventory[_arg1.id] != null)
            {
                _local3 = this.decor_inventory[_arg1.id];
                Tracer.out((("user already owns decor id " + _arg1.id) + "; adding to userDecorIds"));
                _local3.addInstance(_local4);
            } else
            {
                _arg1.addInstance(_local4);
                this.decor_inventory[_arg1.id] = _arg1;
                Tracer.out(("UserData > add_to_decor_inventory: added new decor id " + _arg1.id));
            };
            return (_local4);
        }
        public function set_user_boutique(_arg1:UserBoutique){
            this.boutique = _arg1;
            this.decor_inventory = _arg1.decors;
        }
        public function refresh_daily_vars():void{
            this.didGetBestDressed = false;
            this.daily_free_request = false;
            this.daily_free_give = false;
            this.daily_sponsored_item = false;
            MainViewController.getInstance().show_free_item_btn();
        }
        public function check_show_3_day_reward():Boolean{
            if (this.visits_today == 1)
            {
                Pop_Up.getInstance().display_popup(Pop_Up.THREE_DAY_REWARD);
                return (true);
            };
            return (false);
        }
        public function first_time_visit():Boolean{
            return ((this.visits <= Constants.FIRSTIE_VISIT_COUNT));
        }
        public function check_show_free_item_popup():Boolean{
            if (Constants.SHOW_FREE_ITEM == false)
            {
                return (false);
            };
            if ((((((this.visits > 2)) && ((this.visits_today == 1)))) && (this.daily_sponsored_item)))
            {
                MainViewController.getInstance().open_free_item_popup();
                return (true);
            };
            return (false);
        }
        public function check_show_look_of_the_day():Boolean{
            if ((((((this.visits > 2)) && ((this.visits_today == 1)))) && (!((LookOfTheDayController.items == null)))))
            {
                MainViewController.getInstance().open_look_of_the_day_popup();
                return (true);
            };
            return (false);
        }
        public function show_best_dressed():void{
            this.pending_fcash_reward = Constants.BEST_DRESSED_REWARD;
            DataManager.getInstance().check_user_balances();
            Pop_Up.getInstance().display_popup(Pop_Up.BEST_DRESSED_LIST);
        }
        function process_friends(data:Array){
            var convert:Function;
            convert = function (_arg1:Object, _arg2:int, _arg3:Array){
                return (Friend.parseFBFriendObj(_arg1));
            };
            this.friends = Vector.<Friend>(data.map(convert));
            Tracer.out((("process_friends: have " + this.friends.length) + " friends"));
            this.process_a_list();
        }
        public function process_a_list_json(data:Object):Vector.<Friend>{
            var convert:Function;
            convert = function (_arg1:Object, _arg2:int, _arg3:Array){
                return (Friend.parseAListObj(_arg1));
            };
            this.vip_points = data.vip_points;
            this.a_list = Vector.<Friend>(data.a_list.map(convert));
            this.a_list_ids = Util.make_lookup(data.a_list, "user_ID", false);
            this.process_a_list();
            return (this.a_list);
        }
        function process_a_list(){
            var a_list_test:Function;
            var fb_test:Function;
            a_list_test = function (_arg1:Friend, ... _args){
                return (!((a_list_ids[_arg1.user_id] == undefined)));
            };
            fb_test = function (_arg1:Friend, ... _args){
                _arg1.fb_friend = !((lookup_app_friends[_arg1.user_id] == undefined));
            };
            if ((((this.friends == null)) || ((this.a_list == null))))
            {
                Tracer.out("ERROR > process_a_list : need friends and a_list to process a_list");
                return;
            };
            this.app_friends = this.friends.filter(a_list_test);
            this.non_app_friends = this.friends.filter(Util.negate(a_list_test));
            this.lookup_app_friends = Util.make_lookup(this.app_friends, "user_id", false);
            this.a_list.map(fb_test);
        }
        function update_a_list(_arg1:Array):void{
            Tracer.out(("update_a_list > was: " + this.a_list));
            Util.merge(this.a_list, _arg1, "user_id");
            Tracer.out(("update_a_list > after merge is: " + this.a_list));
        }
        function is_fb_friend(_arg1:String):Boolean{
            return (!((this.lookup_app_friends[_arg1] == undefined)));
        }
        public function check_a_list(_arg1:String):Boolean{
            Tracer.out(("check_a_list : " + _arg1));
            return (this.a_list_ids[_arg1]);
        }
        public function add_to_a_list(_arg1:String, _arg2:String):void{
            var _local3:Friend;
            this.a_list_ids[_arg1] = true;
            if (this.a_list)
            {
                _local3 = new Friend();
                _local3.user_id = _arg1;
                _local3.name = _arg2;
                this.a_list.unshift(_local3);
            };
            Tracer.out((("UserData > add_to_a_list uid : " + _arg1) + " successfully added"));
        }
        public function remove_from_a_list(_arg1:String):void{
            delete this.a_list_ids[_arg1];
            if (this.a_list)
            {
                Util.remove(this.a_list, _arg1, "user_id");
            };
        }
        public function sort_a_list(prop:String){
            var fb_friends_first:Function;
            fb_friends_first = function (_arg1:Friend, _arg2:Friend, _arg3:String){
                if (((_arg1.fb_friend) && ((_arg2.fb_friend == false))))
                {
                    return (-1);
                };
                if ((((_arg1.fb_friend == false)) && (_arg2.fb_friend)))
                {
                    return (1);
                };
                if (_arg1[_arg3] > _arg2[_arg3])
                {
                    return (-1);
                };
                if (_arg2[_arg3] > _arg1[_arg3])
                {
                    return (1);
                };
                return (0);
            };
            this.a_list.sort(Util.partial(fb_friends_first, prop));
        }
        public function accept_a_list(_arg1:String):void{
            this.a_lists_on.unshift(_arg1);
        }
        public function check_a_lists_on(_arg1:String):Boolean{
            Tracer.out(("check_a_lists_on : " + _arg1));
            return ((this.a_lists_on.indexOf(_arg1) > -1));
        }
        public function get_a_list_active_boutique():Vector.<Friend>{
            var test:Function;
            test = function (_arg1:Friend, _arg2:int, _arg3:Vector.<Friend>){
                return (_arg1.activeBoutique);
            };
            if (this.a_list_active_boutique)
            {
                return (this.a_list_active_boutique);
            };
            this.a_list_active_boutique = this.a_list.filter(test);
            return (this.a_list_active_boutique);
        }
        public function update_team(_arg1:Team):void{
            this.team = _arg1;
            ContestantBar.getInstance().update_team_icon();
        }
        public function get my_boutique_url():String{
            return (Util.fresh_url((((Constants.UGC_SERVER_IMAGES + "my_boutique_thumbs/") + DataManager.user_id) + ".png")));
        }
        function set_albums(_arg1:Object):void{
            var _local2:String;
            var _local3:Album;
            this.album_lookup = _arg1;
            this.albums = new Vector.<Album>();
            for (_local2 in this.album_lookup)
            {
                _local3 = new Album(_local2, this.album_lookup[_local2]);
                this.albums.push(_local3);
            };
        }
        public function save_album(_arg1:String, _arg2:String):void{
            var _local3:Album = new Album(_arg1, _arg2);
            this.albums.push(_local3);
            if (this.album_lookup == null)
            {
                this.album_lookup = {};
            };
            this.album_lookup[_arg1] = _arg2;
            DataManager.getInstance().save_album(_local3);
        }
        public function get_album_id_for_type(_arg1:String):String{
            if (this.album_lookup)
            {
                return (this.album_lookup[_arg1]);
            };
            return (null);
        }

    }
}//package com.viroxoty.fashionista

