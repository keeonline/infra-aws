function fn() {
    var config = {
        baseUrl: karate.properties['baseurl'] || 'http://localhost'
    }
    karate.configure('retry', { count: 10, interval: 20000 })
    return config;
}