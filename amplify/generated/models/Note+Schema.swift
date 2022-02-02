// swiftlint:disable all
import Amplify
import Foundation

extension Note {
  // MARK: - CodingKeys 
   public enum CodingKeys: String, ModelKey {
    case id
    case content
    case createdAt
    case updatedAt
  }
  
  public static let keys = CodingKeys.self
  //  MARK: - ModelSchema 
  
  public static let schema = defineSchema { model in
    let note = Note.keys
    
    model.syncPluralName = "Notes"
    
    model.fields(
      .id(),
      .field(note.content, is: .required, ofType: .string),
      .field(note.createdAt, is: .optional, isReadOnly: true, ofType: .dateTime),
      .field(note.updatedAt, is: .optional, isReadOnly: true, ofType: .dateTime)
    )
    }
}
