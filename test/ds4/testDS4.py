#!/usr/bin/env python

import sys
import os

import numpy

import Truchas
import TruchasTest

class DS4(TruchasTest.GoldenTestCase):

  test_name = 'ds4'
  num_procs = 4 # with a parallel executable

  def test_final_temperature(self):
    '''DS4: verifying the final temperature field'''

    # TODO: want to check that the final cycle number is 345

    tol = 1.0e-10
    T    = self.test_output.get_simulation().find_series(id=2).get_data('Z_TEMP')
    Tref = self.gold_output.get_simulation().find_series(id=2).get_data('Z_TEMP')
    error = max(abs(T-Tref)/Tref)
    self.assertTrue(error <= tol)

  def test_final_vof(self):
    '''DS4: verifying the final fluid volume fraction field'''

    # TODO: want to check that the final cycle number is 345

    tol = 1.0e-7
    test = self.test_output.get_simulation().find_series(id=2).get_data('VOF')
    gold = self.gold_output.get_simulation().find_series(id=2).get_data('VOF')
    error = max(abs(test[:,2]-gold[:,2]))
    self.assertTrue(error <= tol)

if __name__ == '__main__':
  import unittest
  unittest.main()
