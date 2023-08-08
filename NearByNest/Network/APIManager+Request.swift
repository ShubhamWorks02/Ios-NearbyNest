//
//  APIManager+Request.swift
//  NearByNest
//
//  Created by Shubham Bhatt on 08/08/23.
//   
//

import Alamofire

// MARK: Enums
enum RequestItemsType {
    
    case refreshToken
    case getOrganizations
    case getUserProfile
    case getAccessToken
    case getDocumentList
    case getDocumentDetail(id: String)
    case getDecision(id: String, approvalId: String, endUrl: String)
    case registerPushWebhook
    case getProposalToDownload(quoteId: Int, proposalId: String)
    case getLegalDocument(quoteId: Int, quotedWaresId: String)
    case getNotificationList
    
}

// MARK: Extensions
// MARK: EndPointType
extension RequestItemsType: EndPointType {
    
    // MARK: Vars & Lets
    var baseURL: String {
        switch self {
        case .refreshToken, .getOrganizations, .getAccessToken:
            return AppConstant.serverURL
        case .getDocumentList, .getDocumentDetail, .getDecision, .registerPushWebhook, .getProposalToDownload, .getLegalDocument, .getUserProfile, .getNotificationList:
            return userManager.organizationBaseURL
        }
    }
    
    var api: String {
        return "api/"
    }
    
    var version: String {
        return "v2/"
    }
    
    var path: String {
        switch self {
        case .refreshToken:
            return "refreshToken"
        case .getOrganizations:
            return "domains/api_organizations.json"
        case .getAccessToken:
            return "oauth/token"
        case .getDocumentList:
            return "compliance_manifests.json"
        case .getDocumentDetail(let id):
            return "compliance_manifests/\(id)"
        case .getDecision(let id, let approvalId, let endUrl):
            return "compliance_manifests/\(id)" + "/approvals/" + "\(String(describing: approvalId))" + "\(String(describing: endUrl))"
        case .registerPushWebhook:
            return "webhook_config.json"
        case .getProposalToDownload(let quoteId, let proposalId):
            return "quote_groups/\(quoteId)/proposals/\(proposalId).pdf"
        case .getLegalDocument(let quoteId, let quotedWaresId):
            return "quote_groups/\(quoteId)/quoted_wares/\(quotedWaresId)/legal_documents/13.pdf"
        case .getUserProfile:
            return "users/profile.json"
        case .getNotificationList:
            return "action_items.json"
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .refreshToken:
            return .post
        case .getOrganizations, .getAccessToken, .getDocumentList, .getDocumentDetail, .getProposalToDownload, .getLegalDocument, .getUserProfile, .getNotificationList:
            return .get
        case .getDecision, .registerPushWebhook:
            return .put
        }
    }
    
    var headers: HTTPHeaders? {
        switch self {
        case .getOrganizations, .getAccessToken:
            return userManager.httpPreTokenHeader
        case .getDocumentList, .getDocumentDetail, .getDecision, .registerPushWebhook, .getProposalToDownload, .getLegalDocument, .getUserProfile:
            return userManager.httpTokenHeader
        default:
            return userManager.httpTokenHeader
        }
    }
    
    var url: URL {
        switch self {
        case .refreshToken:
            return URL(string: self.baseURL + self.version + self.path)!
        case .getOrganizations, .getAccessToken:
             return URL(string: self.baseURL + self.path)!
        case .getDocumentList, .getDocumentDetail, .getDecision, .registerPushWebhook, .getProposalToDownload, .getLegalDocument, .getUserProfile, .getNotificationList:
            return URL(string: self.baseURL + "/" + self.api + self.version + self.path)!
        }
    }
    
    var encoding: ParameterEncoding {
        switch self {
        case .getOrganizations, .getAccessToken, .getDocumentList, .getDocumentDetail, .getProposalToDownload, .getLegalDocument, .getUserProfile, .getNotificationList:
            return URLEncoding.default
        default:
            return JSONEncoding.default
        }
    }
    
}
