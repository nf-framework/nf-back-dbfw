import assert from 'assert';

import { common } from '@nfjs/core';
import { NfcRoles, NfcExSystems } from '../../models/nfc/index.js';
import { execFnEnv } from '../test-helper.js';
import { Op } from '../model.js';
import * as testing from '../broker.js';

describe('@nfjs/back-dbfw/lib/broker', () => {
    describe('getUnit()', () => {
        it('check', async () => {
            await execFnEnv(async (env) => {
                // Arrange
                const connect = env.connect._connect;
                // Act
                const res = await testing.getUnit(connect, 'nfc.roles');
                // Assert
                assert.strictEqual(res.code, 'nfc.roles');
                assert.strictEqual(res.pkField, 'id');
                assert.notStrictEqual(res.columns.length, 0);
            });
        });
    });
    describe('getUnitBp()', () => {
        it('check', async () => {
            await execFnEnv(async (env) => {
                // Arrange
                const connect = env.connect._connect;
                // Act
                const res = await testing.getUnitBp(connect, 'nfc.roles.add');
                // Assert
                assert.strictEqual(res.code, 'nfc.roles.add');
            });
        });
    });
    describe('prepareSql()', () => {
        /** @type NfcUnit */
        const testUnit = {
            code: 'test.testing',
            tableSchema: 'test',
            tableName: 'testing',
            opt: {
                divideType: 'sys',
                idGenMethod: 'main',
            },
            columns: [
                { name: 'id', datatype: 'int8' },
                { name: 'code', datatype: 'text' },
                { name: 'caption', datatype: 'text' },
            ],
            pkField: 'id',
            pkType: 'int8'
        };
        it('add', () => {
            // Arrange
            // Act
            const res = testing.prepareSql(testUnit, 'add', { caption: '_test_testing', wrong: '0' });
            // Assert
            assert.strictEqual(res.sql, 'insert into "test"."testing" ("caption") values (($1->>\'caption\')::text) returning "id"::text;');
        });
        it('add ext', () => {
            // Arrange
            const unit = common.cloneDeep(testUnit);
            unit.opt.idGenMethod = 'ext';
            // Act
            const res = testing.prepareSql(unit, 'add', { id: 146, caption: '_test_testing', wrong: '0' });
            // Assert
            assert.strictEqual(res.sql, 'insert into "test"."testing" ("id","caption") values (($1->>\'id\')::int8,($1->>\'caption\')::text) returning "id"::text;');
        });
        it('upd', () => {
            // Arrange
            // Act
            const res = testing.prepareSql(testUnit, 'upd', { id: 146, caption: '_test_testing', wrong: '0' });
            // Assert
            assert.strictEqual(res.sql, 'update only "test"."testing" set "caption" = ($1->>\'caption\')::text where "id" = $2::int8;');
        });
        it('upd mass', () => {
            // Arrange
            // Act
            const res = testing.prepareSql(testUnit, 'upd', { id: [146, 147], caption: '_test_testing', wrong: '0' });
            // Assert
            assert.strictEqual(res.sql, 'update only "test"."testing" set "caption" = ($1->>\'caption\')::text where "id" = any($2::int8[]);');
        });
        it('del', () => {
            // Arrange
            // Act
            const res = testing.prepareSql(testUnit, 'del', { id: 146, caption: '_test_testing', wrong: '0' });
            // Assert
            assert.strictEqual(res.sql, 'delete from only "test"."testing" where "id" = $2::int8;');
        });
        it('del mass', () => {
            // Arrange
            // Act
            const res = testing.prepareSql(testUnit, 'del', { id: [146, 147], caption: '_test_testing', wrong: '0' });
            // Assert
            assert.strictEqual(res.sql, 'delete from only "test"."testing" where "id" = any($2::int8[]);');
        });
        it('get', () => {
            // Arrange
            // Act
            const res = testing.prepareSql(testUnit, 'get', { id: 146 });
            // Assert
            assert.strictEqual(res.sql, 'select * from "test"."v4testing" where "id" = $1::int8;');
        });
        it('find', () => {
            // Arrange
            // Act
            const res = testing.prepareSql(testUnit, 'find', { id: 146, caption: '_test_testing', wrong: '0' });
            // Assert
            assert.strictEqual(res.sql, `select * from "test"."v4testing" where "id" = (($1::json)->>'id')::int8 and "caption" = (($1::json)->>'caption')::text;`);
        });
        it('find param arr', () => {
            // Arrange
            // Act
            const res = testing.prepareSql(testUnit, 'find', { id: [146,147], caption: '_test_testing', wrong: '0' });
            // Assert
            assert.strictEqual(res.sql, `select * from "test"."v4testing" where "id" = any((($1::json)->>'id')::int8[]) and "caption" = (($1::json)->>'caption')::text;`);
        });
    });
    describe('broker()', () => {
        it('add', async () => {
            await execFnEnv(async (env) => {
                // Arrange
                const connect = env.connect._connect;
                // Act
                const res = await testing.broker(connect, 'nfc.roles.add', { code: '__tst', caption: '__tst' });
                const role = await NfcRoles.findOne(env.connect, { where: { id: res.data.id } });
                // Assert
                assert.equal(res.data.id, role.id);
            });
        });
        it('upd', async () => {
            await execFnEnv(async (env) => {
                // Arrange
                const role = new NfcRoles({ code: '__tst', caption: '__tst' });
                await role.save(env.connect);
                // Act
                const res = await testing.broker(env.connect._connect, 'nfc.roles.upd', { id: role.id, caption: '__tst2' });
                const role2 = await NfcRoles.findOne(env.connect, { where: { code: '__tst' } });
                // Assert
                assert.strictEqual(role2.caption, '__tst2');
            });
        });
        it('upd mass', async () => {
            await execFnEnv(async (env) => {
                // Arrange
                const connect = env.connect._connect;
                const r1 = await NfcExSystems.new(env, { code: '__tst1', caption: '__tst1', is_stopped: true });
                const r2 = await NfcExSystems.new(env, { code: '__tst2', caption: '__tst2', is_stopped: true });
                await r1.save();
                await r2.save();
                // Act
                await testing.broker(connect, 'nfc.ex_systems.upd', { id: [r1.id, r2.id], is_stopped: false });
                const res = await NfcExSystems.findAll(env, { where: { id: { [Op.in]: [r1.id, r2.id] } } });
                // Assert
                assert.strictEqual(res[0].is_stopped, false);
                assert.strictEqual(res[1].is_stopped, false);
            });
        });
        it('del', async () => {
            await execFnEnv(async (env) => {
                // Arrange
                const connect = env.connect._connect;
                const role = await NfcRoles.new(env, { code: '__tst', caption: '__tst' });
                await role.save();
                // Act
                const res = await testing.broker(connect, 'nfc.roles.del', { id: role.id });
                const role2 = await NfcRoles.findOne(env, { where: { id: role.id } });
                // Assert
                assert.strictEqual(role2, undefined);
            });
        });
        it('del mass', async () => {
            await execFnEnv(async (env) => {
                // Arrange
                const connect = env.connect._connect;
                const r1 = await NfcRoles.new(env, { code: '__tst1', caption: '__tst1' });
                const r2 = await NfcRoles.new(env, { code: '__tst2', caption: '__tst2' });
                await r1.save();
                await r2.save();
                // Act
                await testing.broker(connect, 'nfc.roles.del', { id: [r1.id, r2.id] });
                const res = await NfcRoles.findAll(env, { where: { id: { [Op.in]: [r1.id, r2.id] } } });
                // Assert
                assert.strictEqual(res.length, 0);
            });
        });
        it('get', async () => {
            await execFnEnv(async (env) => {
                // Arrange
                const connect = env.connect._connect;
                const add = await testing.broker(connect, 'nfc.roles.add', { code: '__tst', caption: '__tst' });
                // Act
                const res = await testing.broker(connect, 'nfc.roles.get', { id: add?.data?.id });
                // Assert
                assert.equal(res?.data?.id, add?.data?.id);
            });
        });
        it('find', async () => {
            await execFnEnv(async (env) => {
                // Arrange
                const connect = env.connect._connect;
                const add = await testing.broker(connect, 'nfc.roles.add', { code: '__tst', caption: '__tst' });
                // Act
                const res = await testing.broker(connect, 'nfc.roles.find', { code: '__tst' });
                // Assert
                assert.equal(res?.data?.[0]?.id, add?.data?.id);
            });
        });
        it('find arr', async () => {
            await execFnEnv(async (env) => {
                // Arrange
                const connect = env.connect._connect;
                const add1 = await testing.broker(connect, 'nfc.roles.add', { code: '__tst', caption: '__tst' });
                const add2 = await testing.broker(connect, 'nfc.roles.add', { code: '__tst2', caption: '__tst2' });
                // Act
                const res = await testing.broker(connect, 'nfc.roles.find', { code: ['__tst','__tst2'] });
                // Assert
                // TODO порядок не гарантирован в возврате
                assert.equal(res?.data?.[0]?.id, add1?.data?.id);
            });
        });
    });
});
