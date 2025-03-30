json.bubbles @bubbles do |bubble|
  json.title bubble.title

  if stage = bubble.stage
    json.stage stage.name
  end
end
