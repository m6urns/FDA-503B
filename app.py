from flask import Flask, request, render_template

app = Flask(__name__)

@app.route('/')
def index():
    return "503B Information Web App"
    
@app.route('/facility')
def facility():
    facility_id = request.args.get('facility_id', default = 'Null', type = str)
        
    if facility_id == 'Null':
        return 'Please select a facility from the drop down.'
        
@app.route('/active')
def active():
    active_id = request.args.get('active_id', default = 'Null', type = str)
        
    if active_id == 'Null':
        return 'Please select an active from the drop down.'
        
if __name__ == '__main__':
    app.run(debug=True)
    
    