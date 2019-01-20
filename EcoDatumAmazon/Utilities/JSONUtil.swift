//
//  JSONUtil.swift
//  EcoDatumAmazon
//
//  Created by Kenneth Wingerden on 1/19/19.
//  Copyright © 2019 Kenneth Wingerden. All rights reserved.
//

import Foundation

extension JSONEncoder {
  
  static func ecoDatumJSONEncoder(_ outputFormatting: JSONEncoder.OutputFormatting? = nil) -> JSONEncoder {
    let encoder = JSONEncoder()
    encoder.dateEncodingStrategy = .iso8601
    if let outputFormatting = outputFormatting {
      encoder.outputFormatting = outputFormatting
    }
    return encoder
  }
  
}

extension JSONDecoder {
  
  static func ecoDatumJSONDecoder() -> JSONDecoder {
    let decoder = JSONDecoder()

    // A custom decoder function is needed since some of the older data was collected using date's
    // default decoding strategy. The standard is now to use ISO 8601 date format. To accomodate
    // this, test to see of the date is encoded in either the ISO 8601 date format or date's
    // default encoding strategy.
    func customDecoder(_ decoder: Decoder) throws -> Date {
      var date: Date?
      switch decoder.codingPath.last {
        // Right now, the collectionDate is the only date that needs to be handled.
      case EcoFactor.CodingKeys.collectionDate?:
        let container = try decoder.singleValueContainer()
        do {
          let iso8601FormattedString = try container.decode(String.self)
          date = ISO8601DateFormatter().date(from: iso8601FormattedString)
        } catch {
          let value = try container.decode(Double.self)
          date = Date(timeIntervalSinceReferenceDate: value)
        }
      default:
        break
      }
      if let date = date {
        return date
      } else {
        let errorContext = DecodingError.Context(
          codingPath: decoder.codingPath,
          debugDescription: "Failed to convert date")
        throw DecodingError.typeMismatch(Date.self, errorContext)
      }
    }

    decoder.dateDecodingStrategy = .custom(customDecoder)

    return decoder
  }
  
}
