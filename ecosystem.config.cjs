module.exports = {
    apps: [
        {
            name: "api-doc-service",
            script: "dist/services/docs/app.js",
            watch: false,
            env: {
                PORT: 3000, // Ensure correct port
            },
        },
        {
            name: "company-service",
            script: "dist/services/company/app.js",
            watch: false, // Restart on file changes
            env: {
                PORT: 3001, // Ensure correct port
            },
        },
        {
            name: "user-service",
            script: "dist/services/user/app.js",
            watch: false,
            env: {
                PORT: 3002, // Ensure correct port
            },
        },
        {
            name: "module-service",
            script: "dist/services/module/app.js",
            watch: false,
            env: {
                PORT: 3003, // Ensure correct port
            },
        }
        ,
        {
            name: "role-based-access-control-service",
            script: "dist/role-based-access-control/app.js",
            watch: false,
            env: {
                PORT: 3004, // Ensure correct port
            },
        }
    ],
};
