# -*- Mode: Python; coding: utf-8; indent-tabs-mode: nil; tab-width: 4 -*-
# Copyright 2013 Canonical
#
# This program is free software: you can redistribute it and/or modify it
# under the terms of the GNU General Public License version 3, as published
# by the Free Software Foundation.

"""Calendar app autopilot emulators."""


class MainWindow(object):
    """An emulator class that makes it easy to interact with the
    calendar-app.

    """
    def __init__(self, app):
        self.app = app

    def get_create_event_page(self):
        return self.app.select_single("NewEvent")

    def get_new_event_name_input_box(self):
        return self.app.select_single("TextField", objectName="newEventName")

    def get_event_start_time_field(self):
        return self.app.select_single("TextField", objectName="startTimeInput")

    def get_event_end_time_field(self):
        return self.app.select_single("TextField", objectName="endTimeInput")

    def get_event_location_field(self):
        return self.app.select_single(
            "TextField", objectName="eventLocationInput")

    def get_event_people_field(self):
        return self.app.select_single(
            "TextField", objectName="eventPeopleInput")

    def get_event_save_button(self):
        return self.app.select_single("Button", objectName="eventSaveButton")

    def get_event_view(self):
        return self.app.select_single("EventView")
    
    def get_title_label(self):
        return self.app.select_single("Label", objectName="titleLabel")
    
