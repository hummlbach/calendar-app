# -*- Mode: Python; coding: utf-8; indent-tabs-mode: nil; tab-width: 4 -*-
# Copyright 2013 Canonical
#
# This program is free software: you can redistribute it and/or modify it
# under the terms of the GNU General Public License version 3, as published
# by the Free Software Foundation.

"""Calendar app autopilot tests."""

from __future__ import absolute_import

from autopilot.matchers import Eventually
from testtools.matchers import Equals, NotEquals
import logging

import math

from calendar_app.tests import CalendarTestCase

from datetime import datetime
from dateutil.relativedelta import relativedelta
from time import sleep

logger = logging.getLogger(__name__)


class TestMonthView(CalendarTestCase):

    def setUp(self):
        super(TestMonthView, self).setUp()
        self.assertThat(self.main_view.visible, Eventually(Equals(True)))
        self.main_view.switch_to_tab("monthTab")

        self.assertThat(
            self.main_view.get_month_view, Eventually(NotEquals(None)))

        self.month_view = self.main_view.get_month_view()

    def _change_month(self, delta):
        month_view = self.main_view.get_month_view()
        direction = int(math.copysign(1, delta))

        for _ in range(abs(delta)):
            before = month_view.currentMonth.datetime
            after = before + relativedelta(months=direction)

            #prevent timing issues with swiping
            self.main_view.swipe_view(direction, month_view)
            self.assertThat(lambda:
                            self.month_view.currentMonth.datetime.month,
                            Eventually(Equals(after.month)))
            self.assertThat(lambda:
                            self.month_view.currentMonth.datetime.year,
                            Eventually(Equals(after.year)))

    def _assert_today(self):
        today = datetime.today()
        self.assertThat(lambda: self.month_view.currentMonth.datetime.day,
                        Eventually(Equals(today.day)))
        self.assertThat(lambda: self.month_view.currentMonth.datetime.month,
                        Eventually(Equals(today.month)))
        self.assertThat(lambda: self.month_view.currentMonth.datetime.year,
                        Eventually(Equals(today.year)))

    def _test_go_to_today(self, delta):
        self._assert_today()
        self._change_month(delta)
        self.main_view.open_toolbar().click_button("todaybutton")
        self._assert_today()

    def test_monthview_go_to_today_next_month(self):
        self._test_go_to_today(1)

    def test_monthview_go_to_today_prev_month(self):
        self._test_go_to_today(-1)

    def test_monthview_go_to_today_next_year(self):
        self._test_go_to_today(12)

    def test_monthview_go_to_today_prev_year(self):
        self._test_go_to_today(-12)
