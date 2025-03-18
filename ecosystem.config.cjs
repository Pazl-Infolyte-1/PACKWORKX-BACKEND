module.exports = {
    apps: [
        {
            name: "api-doc-service",
            script: "dist/services/docs/app.js",
            watch: false,
            env: {
                PORT: 4000, // Ensure correct port
            },
        },
        {
            name: "company-service",
            script: "dist/services/company/app.js",
            watch: false, // Restart on file changes
            env: {
                PORT: 4001, // Ensure correct port
            },
        },
        {
            name: "user-service",
            script: "dist/services/user/app.js",
            watch: false,
            env: {
                PORT: 4002, // Ensure correct port
            },
        },
        {
            name: "module-service",
            script: "dist/services/module/app.js",
            watch: false,
            env: {
                PORT: 4003, // Ensure correct port
            },
        }
        ,
        {
            name: "role-based-access-control-service",
            script: "dist/services/role-based-access-control/app.js",
            watch: false,
            env: {
                PORT: 4004, // Ensure correct port
            },
        }, {
            name: "form-Service",
            script: "dist/services/form_fields/app.js",
            watch: false,
            env: {
                PORT: 4005, // Ensure correct port
            },
        }
    ],
};
