/* eslint-env mocha */
import assert from 'assert';
import { describe, it } from 'mocha';
import { execFnEnv } from '../../test-helper.js';
import * as testing from '../ei.js';
import { nfc as nfcModel } from '../../../models/index.js';

describe('@nfjs/back-dbfw/lib/roles/ie', () => {
    describe('getRoleUnitPrivs()', () => {
        it('check', async () => {
            await execFnEnv(async (env) => {
                // Arrange
                const role = '_tst';
                const r = new nfcModel.NfcRoles({ code: role, caption: role });
                await r.save(env.connect);
                // Act
                const res = await testing.getRoleUnitPrivs(env, [role]);
                // Assert
                assert.strictEqual(res.code, role);
            });
        });
    });
});
