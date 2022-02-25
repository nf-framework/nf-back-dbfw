import assert from 'assert';

import * as testing from '../model.js';

class TestModelTableSubOrigin extends testing.Model {
    static _def = {
        schema: 'public',
        table: 'test_model_table_sub',
        view: 'v4test_model_table_sub',
        pk: 'id'
    }

    static _schema = {
        type: 'object',
        properties: {
            id: { type: 'number' },
            pid: { type: 'number' },
            val: { type: 'string' }
        },
        required: ['pid', 'val'],
    };

    static _validationSchema = testing.Model._validator.compile(TestModelTableSubOrigin._schema);

    id;

    pid;

    val;

    constructor(values, options) {
        super();
        this._constructor(values, options);
    }
}

class TestModelTableSub extends TestModelTableSubOrigin {
    test() {
        return 'sub';
    }
}

class TestModelTableOrigin extends testing.Model {
    static _def = {
        schema: 'public',
        table: 'test_model_table',
        view: 'v4test_model_table',
        pk: 'id'
    }

    static _hasdef = {
        sub: {
            model: TestModelTableSub,
            as: 'sub_sub',
            fk: 'pid',
            cmpFields: 'val'
        }
    }

    static _schema = {
        type: 'object',
        properties: {
            id: { type: 'number' },
            code: { type: 'string' },
            caption: { type: 'string' }
        },
        required: ['code', 'caption'],
    };

    static _validationSchema = testing.Model._validator.compile(TestModelTableOrigin._schema);

    id;

    code;

    caption;

    constructor(values, options) {
        super();
        this._constructor(values, options);
    }
}

class TestModelTable extends TestModelTableOrigin {
    test() {
        return 'main';
    }
}

const code = 'test.code';
const caption = 'test.caption';

describe('@nfjs/back-dbfw/lib/model', () => {
    describe('new', () => {
        it('check', () => {
            // Arrange
            // Act
            const res = new TestModelTable({ code, caption });
            // Assert
            assert.strictEqual(res.code, code);
        });
        it('include all', () => {
            // Arrange
            // Act
            const res = new TestModelTable({ code, caption, sub_sub: [{ val: 5 }, { val: 7 }] }, { include: 'all' });
            // Assert
            assert.strictEqual(res.sub_sub[0] instanceof TestModelTableSub, true);
            assert.strictEqual(res.sub_sub[1] instanceof TestModelTableSub, true);
        });
        it('include custom', () => {
            // Arrange
            // Act
            const res = new TestModelTable(
                { code, caption, sub_custom: [{ val: 5 }, { val: 7 }] },
                { include: [{
                    model: TestModelTableSub,
                    as: 'sub_custom',
                    prop: 'sub_custom',
                    fk: 'pid',
                    cmpFields: 'val'
                }] }
            );
            // Assert
            assert.strictEqual(res.sub_custom[0] instanceof TestModelTableSub, true);
            assert.strictEqual(res.sub_custom[1] instanceof TestModelTableSub, true);
        });
    });
    describe('_assignSaveOnlyAttr', () => {
        it('check', () => {
            // Arrange
            const role = new TestModelTable({ code, caption });
            // Act
            role._assignSaveOnlyAttr(['code', 'caption']);
            role._assignSaveOnlyAttr(['caption']);
            // Assert
            assert.deepStrictEqual(role._saveOnlyAttr, ['code', 'caption']);
        });
    });
    describe('assign', () => {
        it('check', () => {
            // Arrange
            const role = new TestModelTable({ code });
            // Act
            role.assign({ caption, another: 'Property' });
            // Assert
            assert.strictEqual(role.caption, caption);
            assert.strictEqual(role.another, undefined);
        });
        it('allowOtherProperties', () => {
            // Arrange
            const role = new TestModelTable({ code });
            // Act
            role.assign({ caption, another: 'Property' }, { allowOtherProperties: true });
            // Assert
            assert.strictEqual(role.another, 'Property');
        });
        it('assignSaveOnlyAttr', () => {
            // Arrange
            const role = new TestModelTable({ code, caption });
            // Act
            role.assign({ caption: 'another' }, { assignSaveOnlyAttr: true });
            // Assert
            assert.strictEqual(role.caption, 'another');
            assert.deepStrictEqual(role._saveOnlyAttr, ['caption']);
        });
        it('include', () => {
            // Arrange
            const role1 = { code: 'r1', caption: 'r1', sub_sub: [{ val: 1 }, { val: 2 }] };
            const role2 = { code: 'r1', caption: 'r2', sub_sub: [{ val: 2 }, { val: 3 }] };
            const role = new TestModelTable(role1, { include: 'all' });
            // Act
            role.assign(role2, { include: 'all' });
            // Assert
            assert.strictEqual(role.caption, 'r2');
            assert.strictEqual(role.sub_sub._mutations.add[0].val, 3);
            assert.strictEqual(role.sub_sub._mutations.upd[0].val, 2);
            assert.strictEqual(role.sub_sub._mutations.del[0].val, 1);
        });
    });
    describe('getParams', () => {
        it('check', () => {
            // Arrange
            const role = new TestModelTable({ code, caption });
            // Act
            const params = role.getParams();
            // Assert
            assert.deepStrictEqual(params.id, undefined);
            assert.deepStrictEqual(params.code, code);
            assert.deepStrictEqual(params.caption, caption);
        });
        it('_assignSaveOnlyAttr', () => {
            // Arrange
            const role = new TestModelTable({ id: 2, code, caption });
            // Act
            role._assignSaveOnlyAttr(['caption']);
            const params = role.getParams();
            // Assert
            assert.deepStrictEqual(params.id, 2);
            assert.deepStrictEqual(params.code, undefined);
            assert.deepStrictEqual(params.caption, caption);
        });
    });
    describe('validate', () => {
        it('check schema type mismatch', async () => {
            // Arrange
            const role = new TestModelTable({ code: 1, caption: 'string' });
            // Act
            const res = await role.validate();
            // Assert
            assert.strictEqual(res.valid, false);
            assert.strictEqual(res.errors[0].property, 'code');
        });
        it('check schema required', async () => {
            // Arrange
            const role = new TestModelTable({ code: 'string' });
            // Act
            const res = await role.validate();
            // Assert
            assert.strictEqual(res.valid, false);
            assert.strictEqual(res.errors[0].property, 'caption');
        });
        it('_validations', async () => {
            // Arrange
            TestModelTable._validations = [async function () {
                if (this.code === code) return { valid: false, message: 'not', property: 'code' };
                return { valid: true };
            }];
            const role = new TestModelTable({ code, caption });
            // Act
            const res = await role.validate();
            // Assert
            assert.deepStrictEqual(res.valid, false);
            assert.deepStrictEqual(res.message, 'not');
        });
    });
});
