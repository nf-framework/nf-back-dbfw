export default {
    "@main": {
        provider: "default",
        action: "nfc.users.mod",
        type: "broker",
        out: "id"
    },
    userroles: {
        "@add": [
            {
                action: "nfc.userroles.add",
                provider: "default",
                type: "broker",
                args: {
                    user_id: "/id",
                    "...": "*"
                },
                out: "id"
            }
        ],
        "@del": [
            {
                action: "nfc.userroles.del",
                provider: "default",
                type: "broker",
                args: {
                    id: "id"
                }
            }
        ]
    }
};