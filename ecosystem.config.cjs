module.exports = {
    apps: [
        {
            name: "company-service",
            script: "dist/services/company/app.js",
            watch: true, // Restart on file changes
            env: {
                PORT: 3000, // Ensure correct port
            },
        },
        // {
        //     name: "user-service",
        //     script: "dist/services/user/app.js",
        //     watch: true,
        //     env: {
        //         PORT: 3001, // Ensure correct port
        //     },
        // },
        // {
        //     name: "api-docd-service",
        //     script: "dist/services/docs/app.js",
        //     watch: true,
        //     env: {
        //         PORT: 3002, // Ensure correct port
        //     },
        // },
    ],
};
