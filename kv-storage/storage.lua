local data = {}

function get(key)
    return data[key]
end

function set(key, value)
    data[key] = value
end

function delete(key)
    data[key] = nil
end

return {
    get = get,
    set = set,
    delete = delete
}