//
//  APIManager+ErrorHandeling.swift
//  NearByNest
//
//  Created by Shubham Bhatt on 08/08/23.
//   
//

import UIKit
import Alamofire

struct APIParams {
    
    struct Authentication {
        static let refreshToken = "refreshToken"
        static let contentType = "Content-Type"
        static let authorization = "Authorization"
        static let email = "email"
        static let password = "password"
        static let firstName = "first_name"
        static let lastName = "last_name"
        static let confirmPassword = "confirmPassword"
        static let signUpType = "signup_type"
        static let socialId = "social_id"
    }
    
    struct ComplianceManifest {
        static let manifestType = "manifest_type"
        static let approvalEmails = "approval_emails"
        static let submittedBy = "submitted_by"
        static let complianceTypes = "compliance_types"
        static let dynamicFormId = "dynamic_form_id"
        static let status = "status"
        static let page = "page"
        static let perPage = "per_page"
        
    }
    
    struct NotificationListing {
        static let name = "name"
        static let page = "page"
        static let perPage = "per_page"
        static let complianceMobileApp = "Compliance Mobile App"
    }
    
    struct MakeDecision {
        static let approval = "approval"
        static let reason = "reason"
        static let reassignApprovalTo = "reassign_approval_to"
    }
    
    struct PushWebhook {
        static let name = "name"
        static let url = "url"
        static let params = "params"
        static let deviceToken = "deviceToken"
        static let appID = "app_id"
        static let isActive = "active"
        static let contentType = "content_type"
        static let allEvent = "all_events"
        static let appName = "app_name"
        static let playerId = "player_id"
        static let externalUserId = "external_user_id"
        static let notificationMethod = "notification_method"
        static let eventKey = "event_key"
        static let eventIdKey = "event_id_key"
        static let events = "events"
        static let approver = "approver"
        static let newRequest = "new_request"
        static let approvalRequested = "approval_requested"
        static let requestComplianceApproved = "request_compliance_approved"
        static let complianceManifestApprovedBy = "compliance_manifest_approved_by"
        static let complianceSubmitted = "compliance_submitted"
        static let purchaseComplianceApproved = "purchase_compliance_approved"
        static let purchaseComplianceDenied = "purchase_compliance_denied"
        static let proposalComplianceApproved = "proposal_compliance_approved"
        static let proposalComplianceDenied = "proposal_compliance_denied"
        static let userLegalObligationChanged = "user_legal_obligation_changed"
        static let proposalApprovalRequest = "proposal_approval_requested"
    }
       
    struct FacetAPI {
        static let waitingOnEmails = "facets[waiting_on_emails][]"
        static let manifesttype = "facets[manifest_type][]"
        static let approvalEmails = "facets[approval_emails][]"
        static let submittedby = "facets[submitted_by][]"
        static let complianceTypes = "facets[compliance_types][]"
        static let dynamicFormName = "facets[dynamic_form_name][]"
        static let statusApi = "facets[status][]"
        static let query = "q"
    }
    
}

/// API Error
struct APIError {

    // MARK: Alerts
    static let defaultAlertTitle   = "warning"
    static let errorAlertTitle     = "error"
    static let genericErrorMessage = "Something went wrong, please try again."
    static let unprocessableEntity = "Unprocessable Entity"
    static let notFound            = "Not Found"
    static let parameterMissing    = "Missing Param"
    static let unAuthorizeUser     = "Authorisation Error"
    static let noInternet          = "No Internet Connection"
    static let noData              = "No data"
    static let failToAuthenticate  = "Fail to authenticate, please try again."
}

extension APIManager {
    
    func parseApiError(dataResponse: DataResponse<Any>?) -> CustomError {
        guard let data = dataResponse else {
            return CustomError(title: APIError.errorAlertTitle, body: APIError.genericErrorMessage)
        }
        let decoder = JSONDecoder()
        if let jsonData = data.data, let error = try? decoder.decode(NetworkError.self, from: jsonData) {
             return CustomError(title: APIError.errorAlertTitle, body: error.message)
        }
        if let statusCode = data.response?.statusCode {
           return parseHTTPStatusCodeErrors(statusCode: statusCode)
        } else {
            return CustomError(title: APIError.errorAlertTitle, body: APIError.noInternet)
        }
    }

    func parseHTTPStatusCodeErrors(statusCode: Int) -> CustomError {
        if APIManager.errorCodeList.contains(statusCode) {
            if statusCode == 422 { // Unprocessable Entity
                return CustomError(title: APIError.errorAlertTitle, body: APIError.unprocessableEntity)
            } else if statusCode == 404 { // not found
                return CustomError(title: APIError.errorAlertTitle, body: APIError.notFound)
            } else if statusCode == 400 { // paramter required error
                return CustomError(title: APIError.errorAlertTitle, body: APIError.parameterMissing)
            } else if statusCode == 403 { // forbidden
                return CustomError(title: APIError.errorAlertTitle, body: APIError.unAuthorizeUser)
            } else if statusCode == 401 { // unauthorised
                return CustomError(title: APIError.errorAlertTitle, body: APIError.unAuthorizeUser)
            }
        } else if statusCode == -1009 || statusCode == -1001 || statusCode == -1003 {
            // No Internet
            return CustomError(title: APIError.errorAlertTitle, body: APIError.noInternet)
        } else if statusCode == 500 { // Something went Wrong
            return CustomError(title: APIError.errorAlertTitle, body: APIError.genericErrorMessage)
        }
        return CustomError(title: APIError.errorAlertTitle, body: APIError.genericErrorMessage)
    }
    
}
