package  {
	import flash.display.MovieClip;
	import flash.events.MouseEvent;

	// Timer
    import flash.utils.Timer;

    // Events
    import flash.events.MouseEvent;
    import flash.events.TimerEvent;

    // Used to make nice buttons / doto themed stuff
    import flash.utils.getDefinitionByName;

	public class loadhelper extends MovieClip {
		// element details filled out by game engine
		public var gameAPI:Object;
		public var globals:Object;
		public var elementName:String;

		// The placeholder
        public var buttonResume:MovieClip;
        public var buttonQuit:MovieClip;
		public var buttonConfirm:MovieClip;

        // The ID of the host
        private var hostID = -1;

		// Size of the custom hud
		private var ourWidth:Number = 1024;
		private var ourHeight:Number = 768;

		// Our timer
		private var timer:Timer;

        // The timer to hide the confirm button
        private var hideConfirm:Timer;

		// called by the game engine when this .swf has finished loading
		public function onLoaded():void {
            // Hook host event
            gameAPI.SubscribeToGameEvent("lh_hostid", onGetHostID);

			// Create the timer
			timer = new Timer(1000);
            timer.addEventListener(TimerEvent.TIMER, updateLoop);
            timer.start();

            // The resume button
            var btnResume:MovieClip = smallButton(buttonResume, "#LH_Resume");
            btnResume.addEventListener(MouseEvent.CLICK, onResumePressed);
            btnResume.x = -btnResume.width/2;
            btnResume.y = 0;

            // The quit button
            var btnQuit:MovieClip = smallButton(buttonQuit, "#LH_Quit");
            btnQuit.addEventListener(MouseEvent.CLICK, onQuitPressed);
            btnQuit.x = -btnQuit.width/2;
            btnQuit.y = 0;

            // The confirm quit button
            var btnConfirm:MovieClip = smallButton(buttonConfirm, "#LH_Confirm");
            btnConfirm.addEventListener(MouseEvent.CLICK, onConfirmPressed);
            btnConfirm.x = -btnQuit.width/2;
            btnConfirm.y = 0;
            buttonConfirm.visible = false;

            // Send the command out to register ourselves as the hoster
            gameAPI.SendServerCommand("lh_register_host");

            // Default to invisible
            this.visible = false;
		}

		// called by the game engine after onLoaded and whenever the screen size is changed
		public function onScreenSizeChanged():void {
			// By default, your 1024x768 swf is scaled to fit the vertical resolution of the game
			//   and centered in the middle of the screen.
			// You can override the scaling and positioning here if you need to.
			// stage.stageWidth and stage.stageHeight will contain the full screen size.

			// Workout the scale
			var scale:Number = stage.stageHeight / ourHeight;

			// Apply the new scale
			this.scaleX = scale;
			this.scaleY = scale;

			// Workout how much of the screensize we can actually use
			var useableWidth = stage.stageHeight*ourWidth/ourHeight;

			// Update the position of this hud (we want the 4:3 section centered)
			x = (stage.stageWidth - useableWidth) / 2;
			y = 0;
		}

        // The server has sent us the host's ID
        private function onGetHostID(args:Object) {
            // Check if we already had the hostID
            if(hostID == -1) {
                // Store the new hostID
                hostID = args.hostID;

                // If we are the host, report how many players are expected
                if(hostID == globals.Players.GetLocalPlayer()) {
                    var totalPlayers = 0;

                    // Loop over all players
                    for(var i=0; i<10; i++) {
                        // Grab this player's slot
                        var state:Number = globals.Loader_waitingforplayers.movieClip.readyPlayers[i];

                        trace(state);

                        // Increase our player count if there is a player in this slot
                        if(state > 0) {
                            totalPlayers++;
                        }
                    }

                    // Report player count to the server
                    gameAPI.SendServerCommand("lh_report_players "+totalPlayers);
                }
            }
        }

		// Runs once every second to ensure everything is good
        private function updateLoop(e:TimerEvent):void {
            // Workout if we are the host, and we should be displaying the content
            var shouldShow = globals.Game.GetState() <= 1;
            var isHost = hostID == globals.Players.GetLocalPlayer();

            // Decide if we should show the panel or not
            if(hostID == -1 && shouldShow) {
                // Send the command out to register ourselves as the hoster
                gameAPI.SendServerCommand("lh_register_host");
            } else if(isHost && shouldShow) {
                // Make ourselves nice and visible
                this.visible = true;
            } else {
                // Kill the timer
                timer.removeEventListener(TimerEvent.TIMER, updateLoop);
                timer.stop();

                // Make invisible
                this.visible = false;
            }
        }

        // Hides the confirm button when called
		private function hideConfirmButton(e:TimerEvent):void {
            // Hide the button, remove timer
            buttonConfirm.visible = false;

            // Delete timer
            hideConfirm = null;
		}

        // When the resume button is pressed
        private function onResumePressed(e:MouseEvent):void {
            // Send the command to the server
            gameAPI.SendServerCommand("lh_resume_game");
        }

        // When the quit button is pressed
        private function onQuitPressed(e:MouseEvent):void {
            // Show the confirm button for 3 seconds
            buttonConfirm.visible = true;

            // If we had another timer running, cancel it
            if(hideConfirm != null) {
                hideConfirm.stop();
                hideConfirm = null;
            }

            // Create new timer to show the confirm button
            hideConfirm = new Timer(3000, 1);
            hideConfirm.addEventListener(TimerEvent.TIMER, hideConfirmButton);
            hideConfirm.start();
        }

        // When the confirm button is pressed
        private function onConfirmPressed(e:MouseEvent):void {
            // Send the command to the server
            gameAPI.SendServerCommand("lh_quit_game");
        }

        // Make a small button
        public static function smallButton(container:MovieClip, txt:String):MovieClip {
            // Grab the class for a small button
            var dotoButtonClass:Class = getDefinitionByName("ChannelTab") as Class;

            // Create the button
            var btn:MovieClip = new dotoButtonClass();
            btn.label = txt;
            container.addChild(btn);

            // Return the button
            return btn;
        }
	}
}
