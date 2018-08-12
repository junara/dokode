# frozen_string_literal: true

module DynamodbClient
  def dynamodb_scan(table_name, loop_max = 3)
    dynamodb

    loop_num = 0
    params = { table_name: table_name }
    loop do
      results = @dynamodb.scan(params)
      yield(results, loop_num)
      loop_num += 1
      break if reach_last?(results, loop_num, loop_max)
      params[:exclusive_start_key] = results.last_evaluated_key
    end
  end

  def reach_last?(scan_results, loop_num, loop_max)
    scan_results.last_evaluated_key.nil? || (loop_num == loop_max)
  end

  def dynamodb
    @dynamodb ||= Aws::DynamoDB::Client.new(region: ENV['AWS_REGION'], access_key_id: ENV['AWS_ACCESS_KEY_ID'], secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'])
  end
end
