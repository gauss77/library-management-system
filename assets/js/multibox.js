var Multibox = /** @class */ (function () {
    function Multibox(instance, boxData, rowData) {
        this.instance = instance;
        this.boxData = boxData;
        this.rowData = rowData;

    }

    Multibox.prototype.reset = function (params) {
        var firstChild = $(this.instance).find('.main')[0];
        $(this.instance).attr('data-index', '0');
        $(this.instance).empty();
        $(this.instance).html(firstChild);
        this.getBox(params);
    };
    Multibox.prototype.getBox = function (params) {

        var box_id = $(this.instance).attr('data-index');
        $(this.instance).attr('data-index', parseInt(box_id) + 1);
        var libdata = {
            box: box_id,
            row: '0',
            instance: this.instance
        };

        if (params) {
            var data = Object.assign({}, params, libdata);
        }
        else {
            var data = libdata;
        }


        var b = $(this.instance).find('.box');

        this.boxData(data, function (html, callbackBoxData) {

            b.last().after(html.view).next().attr('box-index', data.box).attr('row-index', data.row);

            var box_count = parseInt(b.length) - 1;

            if (box_count != 0) {

                b.last().find('.add-box').hide();
                b.last().find('.remove-box').show();
            }
            if (callbackBoxData) {
                callbackBoxData();
            }
        });
    };
    Multibox.prototype.getRow = function (el, target) {
        //var target = $(el).parent().parent();

        var row_id = $(target).attr('row-index');
        $(target).attr('row-index', parseInt(row_id) + 1);

        var data = {
            box: $(target).attr('box-index'),
            row: parseInt(row_id) + 1,
            instance: this.instance
        };

        this.rowData(data, function (html, callbackRowData) {
            $(target).find('.remove-row').show();
            $(target).find('.data-row').last().after(html.view);
            $(el).remove();
            if (callbackRowData) {
                callbackRowData();
            }
        });
    };

    Multibox.prototype.deleteBox = function (el, id, cb) {
        if (id && cb) {
            cb(el, id);
        }
        else {
            $(el).remove();
        }
    };

    Multibox.prototype.deleteRow = function (el, id, cb) {
        if (id && cb) {
            cb(el, id);
        }
        else {
            $(el).remove();
        }
    };
    return Multibox;
}());