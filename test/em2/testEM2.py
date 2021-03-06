#!/usr/bin/env python

import sys
import os

import numpy

import Truchas
import TruchasTest

class EM2(TruchasTest.GoldenTestCase):

  test_name = 'em2'
  num_procs = 4 # with a parallel executable
  
  def get_test_field(self,field,cycle,region=None):
    return self.test_output.get_simulation().find_series(cycle=cycle).get_data(field,region=region)

  def get_gold_field(self,field,cycle,region=None):
    return self.gold_output.get_simulation().find_series(cycle=cycle).get_data(field,region=region)

  def test_joule_heat(self):
    '''Verify the Joule heat fields'''
    tol = 1.0e-8
      
    # Three Joule heat calculations, used for the following cycle groups.
    groups = [ range(0,5), range(5,16), range(16,21) ]
    
    fail = 0
    for g in groups:
      n = g[0]
      test = self.get_test_field('Joule_P',cycle=n)
      gold = self.get_gold_field('Joule_P',cycle=n)
      error = max(abs((test-gold)/gold))
      if error > tol:
        fail = fail + 1
        print 'cycle %2d: joule heat max rel error = %8.2e: FAIL (tol=%8.2e)'%(n,error,tol)
      else:
        print 'cycle %2d: joule heat max rel error = %8.2e: PASS (tol=%8.2e)'%(n,error,tol)
      for j in g[1:]:
        next = self.get_test_field('Joule_P',cycle=j)
        error = max(abs(next-test))
        if error != 0:
          fail = fail + 1
          print 'unexpected change in the Joule heat for cycle %d: FAIL'%(j)
    self.assertTrue(fail==0)
    

  def test_final_temperature(self):
    '''Verify the final temperature field'''
    tol = 1.0e-8
    test = self.get_test_field('Z_TEMP',cycle=20)
    gold = self.get_gold_field('Z_TEMP',cycle=20)
    error = max(abs((test-gold)/gold))
    if error > tol:
      print 'temperature: max rel error = %8.2e: FAIL (tol=%8.2e)'%(error,tol)
      self.assertTrue(False)
    else:
      print 'temperature: max rel error = %8.2e: PASS (tol=%8.2e)'%(error,tol)

if __name__ == '__main__':
  import unittest
  unittest.main()

