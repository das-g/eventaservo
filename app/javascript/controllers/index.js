// This file is auto-generated by ./bin/rails stimulus:manifest:update
// Run that command whenever you add a new controller or create them with
// ./bin/rails generate stimulus controllerName

import { application } from "./application"

import EventMapController from "./event_map_controller"
application.register("event-map", EventMapController)

import EventUserInterestedButtonController from "./event_user_interested_button_controller"
application.register("event-user-interested-button", EventUserInterestedButtonController)

import MapViewController from "./map_view_controller"
application.register("map-view", MapViewController)

import UserController from "./user_controller"
application.register("user", UserController)

import VideoController from "./video_controller"
application.register("video", VideoController)
