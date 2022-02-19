import Foundation

enum EncodingValue {
    case raw(Google_Datastore_V1_Value)
    case container(EncodingContainer)

    var computedRaw: Google_Datastore_V1_Value {
        switch self {
        case .raw(let raw):
            return raw
        case .container(let container):
            return container.computedRaw
        }
    }
}

protocol EncodingContainer {

    var computedRaw: Google_Datastore_V1_Value { get }
}
