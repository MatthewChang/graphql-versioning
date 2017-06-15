require 'spec_helper'

describe GraphQL::Versioning::Instrumentation do
  before(:all) do
    hashAccess = lambda do |key|
      ->(obj, _args, _ctx) { obj[key] }
    end
    ChatMessageType = GraphQL::ObjectType.define do
      name 'Chat Message'
      description 'A session chat message'
      field :id, !types.ID, resolve: hashAccess.call(:id)
      field :session_id, !types.ID, resolve: hashAccess.call(:session_id)
      field :content, !types.String, resolve: hashAccess.call(:content)
    end

    SessionType = GraphQL::ObjectType.define do
      name 'Session'
      description 'A Call9 Session'
      field :id, !types.ID, resolve: hashAccess.call(:id)
      field :field, !types.String, resolve: hashAccess.call(:field)
      field :field, !types.String, resolve: hashAccess.call(:field)
      
      field :chat_messages, types[ChatMessageType], resolve: ->(obj, _args, _ctx) {
        obj[:chat_messages].map { |e| ChatMessages[e] }
      }
    end

    QueryType = GraphQL::ObjectType.define do
      name 'Query'
      description 'The query root of this schema'

      field :session do
        type SessionType
        argument :id, !types.ID
        description 'Find a session by ID'
        resolve ->(_obj, args, _ctx) { Sessions[args['id'].to_i] }
      end
      field :chat_message do
        type ChatMessageType
        argument :id, !types.ID
        description 'Find a chat message by ID'
        resolve ->(_obj, args, _ctx) { ChatMessages[args['id'].to_i] }
      end
    end

    Schema = GraphQL::Schema.define do
      instrument(:field, GraphQL::Versioning::Instrumentation.new(1))
      query QueryType
    end

    Sessions = {
      1 => {
        id: 1, field: 'test', chat_messages: [1]
      },
      2 => {
        id: 2, field: 'data2', chat_messages: []
      }
    }.freeze
    ChatMessages = {
      1 => {
        id: 1,
        session_id: 1,
        content: 'test content'
      }
    }.freeze
    @executeQuery = lambda do |query:, schema: Schema|
      schema.execute(query)
    end
  end

  it 'selects the most current version before or equal to the specified version' do
    query = '{session(id: 1) { id }}'
    puts @executeQuery.call query: query
  end
end
