//
//  JSONError.swift
//  beertab
//
//  Created by Michael Neilens on 10/10/2020.
//

import Foundation

public enum JSONError: String, Error {
    case NoData = "ERROR: no data"
    case ConversionFailed = "ERROR: conversion from JSON failed"
    case ErrorWithData = "ERROR: Non-zero response from service"
    case InvalidURL = "ERROR: invalid URL"
}
