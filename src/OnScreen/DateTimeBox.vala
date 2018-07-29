//
//  Copyright (C) 2015-2016 Abraham Masri @cheesecakeufo
//
//  This program is free software: you can redistribute it and/or modify it
//  under the terms of the GNU Lesser General Public License version 3, as published
//  by the Free Software Foundation.
//
//  This program is distributed in the hope that it will be useful, but
//  WITHOUT ANY WARRANTY; without even the implied warranties of
//  MERCHANTABILITY, SATISFACTORY QUALITY, or FITNESS FOR A PARTICULAR
//  PURPOSE.  See the GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License along
//  with this program.  If not, see <http://www.gnu.org/licenses/>

using Gtk;
using Cairo;

using Komorebi.Utilities;

namespace Komorebi.OnScreen {

    public class DateTimeBox : Clutter.Actor {

        public Clutter.Actor textContainerActor = new Clutter.Actor();
        public Clutter.Text timeText = new Clutter.Text();
        public Clutter.Text dateText = new Clutter.Text();

        public Clutter.Actor shadowContainerActor = new Clutter.Actor();
        public Clutter.Text timeShadowText = new Clutter.Text();
        public Clutter.Text dateShadowText = new Clutter.Text();

        // Vertical Box Layout
        Clutter.BoxLayout boxLayout = new Clutter.BoxLayout() {orientation = Clutter.Orientation.VERTICAL};

        // Time updater
        public uint timeout;

        // Time format
        string timeFormat = "%l:%M %p";

        // Ability to drag
        Clutter.DragAction dragAction = new Clutter.DragAction();

        BackgroundWindow parent;

        public DateTimeBox (BackgroundWindow parent) {

            this.parent = parent;

            // Properties
            textContainerActor.layout_manager = boxLayout;
            shadowContainerActor.layout_manager = boxLayout;
            
            background_color = {0,0,0,0};
            opacity = 0;
            reactive = true;

            textContainerActor.background_color = {0,0,0,0};
            shadowContainerActor.background_color = {0,0,0,0};


            timeText.x_expand = true;
            timeText.y_expand = true;

            timeShadowText.x_expand = true;
            timeShadowText.y_expand = true;

            // Signals
            signalsSetup();

            shadowContainerActor.add_effect(new Clutter.BlurEffect());

            add_action (dragAction);

            textContainerActor.add_child(timeText);
            textContainerActor.add_child(dateText);
            
            shadowContainerActor.add_child(timeShadowText);
            shadowContainerActor.add_child(dateShadowText);

            add_child(shadowContainerActor);
            add_child(textContainerActor);
        }

        void signalsSetup () {

            dragAction.drag_end.connect ((actor, event_x, event_y) => {

                // Disable Parallax
                dateTimeParallax = false;

                // Check if we're at the passing the edge of the screen
                if(x < 0) {
                    moveTo(0);
                } else if (x + width > screenWidth) {
                    moveTo(screenWidth - width, -1);
                }

                if(y < 0) {
                    moveTo(-1, 0);
                } else if (y + height > screenHeight) {
                    moveTo(-1, screenHeight - height);
                }
            });
        }

        public void setDateTime() {

            setAlignment();
            setRotation();

            if(opacity < 1)
                fadeIn();

            opacity = dateTimeAlpha;
            shadowContainerActor.opacity = dateTimeShadowAlpha;

            setPosition();

            timeText.notify["width"].connect(() => {

                setPosition();
                setMargins();

            });

            if(timeout > 0)
                return; // No need to rerun

            timeout = Timeout.add(200, () => {

                if(timeTwentyFour)
                    timeFormat = "%H:%M";
                else
                    timeFormat = "%l:%M %p";

                var glibTime = new GLib.DateTime.now_local().format(timeFormat);
                var glibDate = new GLib.DateTime.now_local().format("%A, %B %e");

                timeText.set_markup(@"<span color='$dateTimeColor' font='$dateTimeTimeFont'>$glibTime</span>");
                dateText.set_markup(@"<span color='$dateTimeColor' font='$dateTimeDateFont'>$glibDate</span>");

                // Apply same to shadows
                timeShadowText.set_markup(@"<span color='$dateTimeShadowColor' font='$dateTimeTimeFont'>$glibTime</span>");
                dateShadowText.set_markup(@"<span color='$dateTimeShadowColor' font='$dateTimeDateFont'>$glibDate</span>");
                return true;
            });
        }

        public void setAlignment() {

            if(dateTimeAlignment == "start") {
                timeText.x_align = Clutter.ActorAlign.START;
                timeShadowText.x_align = Clutter.ActorAlign.START;
            }
            else if(dateTimeAlignment == "center") {
                timeText.x_align = Clutter.ActorAlign.CENTER;
                timeShadowText.x_align = Clutter.ActorAlign.CENTER;
            }
            else {
                timeText.x_align = Clutter.ActorAlign.END;
                timeShadowText.x_align = Clutter.ActorAlign.END;
            }
        }

        public void setRotation() {

            rotation_angle_x = dateTimeRotationX;
            rotation_angle_y = dateTimeRotationY;
            rotation_angle_z = dateTimeRotationZ;
        }

        public void setPosition() {
            var mainActor = parent.mainActor;

            switch (dateTimePosition) {

                case "top_right":
                    x = mainActor.width - width;
                    y = 0;
                break;

                case "top_center":
                    x = (mainActor.width / 2) - (width / 2);
                    y = 0;
                break;

                case "top_left":
                    x = 0;
                    y = 0;
                break;

                case "center_right":
                    x = mainActor.width - width;
                    y = (mainActor.height / 2) - (height / 2);
                break;

                case "center":
                    x = (mainActor.width / 2) - (width / 2);
                    y = (mainActor.height / 2) - (height / 2);
                break;

                case "center_left":
                    x = 0;
                    y = (mainActor.height / 2) - (height / 2);
                break;

                case "bottom_right":
                    x = mainActor.width - width;
                    y = mainActor.height - height;
                break;

                case "bottom_center":
                    x = (mainActor.width / 2) - (width / 2);
                    y = mainActor.height - height;
                break;

                case "bottom_left":
                    x = 0;
                    y = mainActor.height - height;
                break;

                default:
                break;
            }
        }


        public void setMargins() {

            translation_y = 0;
            translation_x = 0;

            translation_y += dateTimeMarginTop;
            translation_x -= dateTimeMarginRight;
            translation_x += dateTimeMarginLeft;
            translation_y -= dateTimeMarginBottom;
        }


        private void moveTo(float x = -1, float y = -1) {

            save_easing_state ();
            set_easing_duration (90);
            if(x != -1) this.x = x;
            if(y != -1) this.y = y;
            set_easing_mode (Clutter.AnimationMode.EASE_IN_SINE);
            restore_easing_state ();
        }

        public void fadeIn (int custom_duration = 90) {

            save_easing_state ();
            set_easing_duration (90);
            opacity = dateTimeAlpha;
            set_easing_mode (Clutter.AnimationMode.EASE_IN_SINE);
            restore_easing_state ();

            reactive = true;

        }

        public void fadeOut () {

            save_easing_state ();
            set_easing_duration (90);
            opacity = 0;
            set_easing_mode (Clutter.AnimationMode.EASE_IN_SINE);
            restore_easing_state ();

            reactive = false;
        }
    }
}
