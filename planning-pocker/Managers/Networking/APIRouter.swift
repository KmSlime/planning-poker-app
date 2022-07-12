//
//  APIRouter.swift
//  FederatedDemo
//
//  Created by Tinh Nguyen on 18/12/2021.
//

import UIKit

enum HttpMethod: String {
    case post = "POST"
    case put = "PUT"
    case get = "GET"
    case delete = "DELETE"
}

enum ContentType: String {
    case urlFormEncoded = "application/x-www-form-urlencoded"
    case applicationJson = "application/json"
    case multipartFormData
}

protocol URLRequestConvertible {
    /// Returns a `URLRequest` or throws if an `Error` was encountered.
    ///
    /// - Returns: A `URLRequest`.
    /// - Throws:  Any error thrown while constructing the `URLRequest`.
    func asURLRequest() -> URLRequest?
}

enum APIRouter: URLRequestConvertible {
    case login(email: String, password: String)
    case signUp(firstName: String, lastName: String, email: String, phone: String, password: String)
    case logOut
    case createNewGame(name: String, idUser: Int)

    static var baseURL: String {
        return "https://58be1a92-cca8-4d6f-9377-2ee2ebfc4972.mock.pstmn.io"
    }

    var path: String {
        switch self {
        case .login:
            return "/external/api/account/v1/login"
        case .logOut:
            return "/external/api/account/v1/logout"
        case .signUp:
            return "/external/api/account/v1/register"
        case .createNewGame:
            return "/api/poker/createNamePoker"
        }
    }

    // MARK: - HTTPMethod

    var method: HttpMethod {
        switch self {
        case .login, .logOut, .signUp, .createNewGame:
            return .post
        default:
            return .get
        }
    }

    // MARK: - Parameters

    var parameters: [String: Any] {
        switch self {
        case .login(email: let email, password: let password):
            return ["emailAddress": email,
                    "password": password]
        case .signUp(firstName: let firstName,
                     lastName: let lastName,
                     email: let email,
                     phone: let phone,
                     password: let password):
            return ["firstName": firstName,
                    "lastName": lastName,
                    "emailAddress": email,
                    "phoneNumber": phone,
                    "password": password]
        case .createNewGame(name: let name, idUser: let idUser):
            return ["name": name, "idUser": idUser]
        default:
            return [:]
        }
    }

    var contentType: ContentType {
        switch self {
        case .login, .signUp, .createNewGame:
            return ContentType.applicationJson
        default:
            return ContentType.urlFormEncoded
        }
    }

    var timeoutInterval: TimeInterval {
        switch self {
        default:
            return 60
        }
    }

    var allHTTPHeaderFields: [String: String] {
        let headerFields = [
            HTTPHeaderFieldKey.contentType.rawValue: HTTPHeaderFieldValue.formUrlencoded.rawValue,
            HTTPHeaderFieldKey.xTenant.rawValue: HTTPHeaderFieldValue.xTenant.rawValue,
            HTTPHeaderFieldKey.appPlatform.rawValue: HTTPHeaderFieldValue.appPlatform.rawValue,
            HTTPHeaderFieldKey.appVersion.rawValue: HTTPHeaderFieldValue.appVersion,
            HTTPHeaderFieldKey.token.rawValue: HTTPHeaderFieldValue.token,
            HTTPHeaderFieldKey.deviceId.rawValue: HTTPHeaderFieldValue.deviceId
        ]

        let headerFieldsJson = [
            HTTPHeaderFieldKey.contentType.rawValue: HTTPHeaderFieldValue.applicationJson.rawValue,
            HTTPHeaderFieldKey.xTenant.rawValue: HTTPHeaderFieldValue.xTenant.rawValue,
            HTTPHeaderFieldKey.appPlatform.rawValue: HTTPHeaderFieldValue.appPlatform.rawValue,
            HTTPHeaderFieldKey.appVersion.rawValue: HTTPHeaderFieldValue.appVersion,
            HTTPHeaderFieldKey.deviceId.rawValue: HTTPHeaderFieldValue.deviceId
        ]

        switch self {
        case .login, .signUp, .createNewGame:
            return headerFieldsJson
        case .logOut:
            var headerWithToken = headerFieldsJson
            headerWithToken[HTTPHeaderFieldKey.token.rawValue] = HTTPHeaderFieldValue.token
            return headerWithToken
        default:
            return headerFields
        }
    }

    // MARK: - URLRequestConvertible

    func asURLRequest() -> URLRequest? {
        guard let url = URL(string: APIRouter.baseURL + path) else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = allHTTPHeaderFields
        var data: Data?
        switch contentType {
        case .applicationJson:
            data = try? JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        case .urlFormEncoded:
            var arrParams = [String]()
            for (key, value) in parameters {
                let param = "\(key)=\(value)"
                arrParams.append(param)
            }
            let stringParams = arrParams.joined(separator: "&")
            data = stringParams.data(using: .utf8)
        case .multipartFormData:
            break
        }
        request.httpBody = data
        request.timeoutInterval = timeoutInterval
        return request
    }
}

enum HTTPHeaderFieldKey: String {
    case contentType = "content-type"
    case xTenant = "x-tenant"
    case appPlatform = "appplatform"
    case appVersion = "appversion"
    case token
    case deviceId = "deviceid"
    case privateKey
}

/// The values for HTTP header fields
public enum HTTPHeaderFieldValue: String {
    case formUrlencoded = "application/x-www-form-urlencoded"
    case applicationJson = "application/json"
    case xTenant = "cloudpayments"
    case appPlatform = "1"

    static var appVersion: String {
        return AppInfo.shared.fullVersion
    }

    static var deviceId: String {
        return UIDevice.current.identifierForVendor?.uuidString ?? ""
    }

    static var token: String {
        return ""
    }
}
