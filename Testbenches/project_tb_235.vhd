-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb is
end project_tb;

architecture project_tb_arch of project_tb is
    constant CLOCK_PERIOD : time := 20 ns;
    signal tb_clk : std_logic := '0';
    signal tb_rst, tb_start, tb_done : std_logic;
    signal tb_add : std_logic_vector(15 downto 0);
    signal tb_k   : std_logic_vector(9 downto 0);

    signal tb_o_mem_addr, exc_o_mem_addr, init_o_mem_addr : std_logic_vector(15 downto 0);
    signal tb_o_mem_data, exc_o_mem_data, init_o_mem_data : std_logic_vector(7 downto 0);
    signal tb_i_mem_data : std_logic_vector(7 downto 0);
    signal tb_o_mem_we, tb_o_mem_en, exc_o_mem_we, exc_o_mem_en, init_o_mem_we, init_o_mem_en : std_logic;

    type ram_type is array (65535 downto 0) of std_logic_vector(7 downto 0);
    signal RAM : ram_type := (OTHERS => "00000000");

constant SCENARIO_LENGTH : integer := 487;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (48,0,163,0,186,0,185,0,41,0,0,0,154,0,30,0,0,0,0,0,33,0,34,0,225,0,145,0,0,0,247,0,37,0,0,0,166,0,0,0,0,0,238,0,0,0,85,0,179,0,0,0,193,0,0,0,84,0,128,0,130,0,185,0,0,0,100,0,99,0,83,0,112,0,33,0,147,0,87,0,143,0,0,0,148,0,218,0,0,0,8,0,192,0,0,0,0,0,234,0,102,0,176,0,130,0,150,0,110,0,233,0,40,0,0,0,71,0,7,0,237,0,159,0,212,0,86,0,0,0,87,0,199,0,79,0,45,0,150,0,120,0,192,0,97,0,229,0,0,0,83,0,253,0,156,0,24,0,133,0,136,0,241,0,0,0,0,0,237,0,16,0,55,0,84,0,147,0,0,0,204,0,238,0,2,0,17,0,197,0,140,0,74,0,0,0,60,0,77,0,162,0,0,0,157,0,152,0,135,0,79,0,106,0,86,0,33,0,0,0,216,0,178,0,0,0,128,0,0,0,0,0,45,0,185,0,70,0,241,0,46,0,213,0,0,0,132,0,241,0,160,0,226,0,184,0,178,0,74,0,249,0,136,0,210,0,0,0,54,0,1,0,180,0,242,0,117,0,51,0,0,0,135,0,24,0,155,0,122,0,0,0,21,0,180,0,77,0,171,0,0,0,0,0,0,0,68,0,229,0,0,0,75,0,165,0,18,0,17,0,0,0,1,0,174,0,243,0,0,0,41,0,128,0,39,0,128,0,0,0,211,0,172,0,156,0,98,0,0,0,168,0,164,0,146,0,99,0,34,0,237,0,104,0,0,0,0,0,76,0,19,0,192,0,66,0,69,0,100,0,173,0,0,0,0,0,122,0,235,0,252,0,88,0,216,0,151,0,161,0,198,0,186,0,188,0,190,0,35,0,207,0,70,0,20,0,129,0,158,0,33,0,39,0,191,0,222,0,111,0,182,0,13,0,24,0,0,0,34,0,0,0,54,0,203,0,0,0,123,0,0,0,48,0,0,0,0,0,231,0,0,0,0,0,176,0,0,0,155,0,45,0,166,0,0,0,0,0,55,0,178,0,11,0,146,0,42,0,109,0,0,0,0,0,231,0,198,0,49,0,70,0,252,0,0,0,76,0,184,0,0,0,132,0,90,0,102,0,171,0,41,0,204,0,0,0,25,0,21,0,17,0,145,0,104,0,38,0,0,0,129,0,196,0,129,0,62,0,29,0,102,0,39,0,192,0,174,0,184,0,208,0,193,0,25,0,167,0,0,0,41,0,12,0,37,0,55,0,30,0,0,0,172,0,25,0,0,0,218,0,178,0,236,0,200,0,214,0,0,0,0,0,24,0,253,0,108,0,81,0,198,0,73,0,8,0,45,0,187,0,40,0,52,0,92,0,109,0,0,0,126,0,171,0,116,0,0,0,65,0,90,0,228,0,29,0,0,0,24,0,0,0,46,0,0,0,148,0,170,0,177,0,72,0,132,0,150,0,154,0,172,0,169,0,0,0,0,0,241,0,56,0,199,0,183,0,10,0,101,0,0,0,0,0,189,0,218,0,160,0,21,0,0,0,85,0,22,0,155,0,240,0,85,0,255,0,209,0,139,0,0,0,0,0,198,0,96,0,1,0,0,0,194,0,178,0,232,0,1,0,0,0,88,0,21,0,174,0,72,0,57,0,134,0,216,0,0,0,216,0,0,0,95,0,229,0,87,0,156,0,106,0,0,0,65,0,71,0,72,0,152,0,0,0,0,0,0,0,246,0,132,0,231,0,29,0,0,0,15,0,75,0,199,0,0,0,223,0,167,0,43,0,211,0,40,0,190,0,7,0,74,0,167,0,136,0,122,0,151,0,183,0,238,0,234,0,0,0,132,0,229,0,191,0,89,0,84,0,93,0,202,0,177,0,0,0,254,0,77,0,240,0,133,0,185,0,215,0,77,0,37,0,0,0,197,0,148,0,194,0,0,0,0,0,125,0,119,0,55,0,157,0,209,0,229,0,12,0,62,0,75,0,159,0,72,0,223,0,6,0,0,0,0,0,0,0,27,0,96,0,193,0,8,0,201,0,92,0,144,0,115,0,197,0,216,0,46,0,79,0,205,0,94,0,139,0,61,0,56,0,141,0,50,0,115,0,10,0,69,0,106,0,160,0,27,0,0,0,22,0,47,0,3,0);
signal scenario_full  : scenario_type := (48,31,163,31,186,31,185,31,41,31,41,30,154,31,30,31,30,30,30,29,33,31,34,31,225,31,145,31,145,30,247,31,37,31,37,30,166,31,166,30,166,29,238,31,238,30,85,31,179,31,179,30,193,31,193,30,84,31,128,31,130,31,185,31,185,30,100,31,99,31,83,31,112,31,33,31,147,31,87,31,143,31,143,30,148,31,218,31,218,30,8,31,192,31,192,30,192,29,234,31,102,31,176,31,130,31,150,31,110,31,233,31,40,31,40,30,71,31,7,31,237,31,159,31,212,31,86,31,86,30,87,31,199,31,79,31,45,31,150,31,120,31,192,31,97,31,229,31,229,30,83,31,253,31,156,31,24,31,133,31,136,31,241,31,241,30,241,29,237,31,16,31,55,31,84,31,147,31,147,30,204,31,238,31,2,31,17,31,197,31,140,31,74,31,74,30,60,31,77,31,162,31,162,30,157,31,152,31,135,31,79,31,106,31,86,31,33,31,33,30,216,31,178,31,178,30,128,31,128,30,128,29,45,31,185,31,70,31,241,31,46,31,213,31,213,30,132,31,241,31,160,31,226,31,184,31,178,31,74,31,249,31,136,31,210,31,210,30,54,31,1,31,180,31,242,31,117,31,51,31,51,30,135,31,24,31,155,31,122,31,122,30,21,31,180,31,77,31,171,31,171,30,171,29,171,28,68,31,229,31,229,30,75,31,165,31,18,31,17,31,17,30,1,31,174,31,243,31,243,30,41,31,128,31,39,31,128,31,128,30,211,31,172,31,156,31,98,31,98,30,168,31,164,31,146,31,99,31,34,31,237,31,104,31,104,30,104,29,76,31,19,31,192,31,66,31,69,31,100,31,173,31,173,30,173,29,122,31,235,31,252,31,88,31,216,31,151,31,161,31,198,31,186,31,188,31,190,31,35,31,207,31,70,31,20,31,129,31,158,31,33,31,39,31,191,31,222,31,111,31,182,31,13,31,24,31,24,30,34,31,34,30,54,31,203,31,203,30,123,31,123,30,48,31,48,30,48,29,231,31,231,30,231,29,176,31,176,30,155,31,45,31,166,31,166,30,166,29,55,31,178,31,11,31,146,31,42,31,109,31,109,30,109,29,231,31,198,31,49,31,70,31,252,31,252,30,76,31,184,31,184,30,132,31,90,31,102,31,171,31,41,31,204,31,204,30,25,31,21,31,17,31,145,31,104,31,38,31,38,30,129,31,196,31,129,31,62,31,29,31,102,31,39,31,192,31,174,31,184,31,208,31,193,31,25,31,167,31,167,30,41,31,12,31,37,31,55,31,30,31,30,30,172,31,25,31,25,30,218,31,178,31,236,31,200,31,214,31,214,30,214,29,24,31,253,31,108,31,81,31,198,31,73,31,8,31,45,31,187,31,40,31,52,31,92,31,109,31,109,30,126,31,171,31,116,31,116,30,65,31,90,31,228,31,29,31,29,30,24,31,24,30,46,31,46,30,148,31,170,31,177,31,72,31,132,31,150,31,154,31,172,31,169,31,169,30,169,29,241,31,56,31,199,31,183,31,10,31,101,31,101,30,101,29,189,31,218,31,160,31,21,31,21,30,85,31,22,31,155,31,240,31,85,31,255,31,209,31,139,31,139,30,139,29,198,31,96,31,1,31,1,30,194,31,178,31,232,31,1,31,1,30,88,31,21,31,174,31,72,31,57,31,134,31,216,31,216,30,216,31,216,30,95,31,229,31,87,31,156,31,106,31,106,30,65,31,71,31,72,31,152,31,152,30,152,29,152,28,246,31,132,31,231,31,29,31,29,30,15,31,75,31,199,31,199,30,223,31,167,31,43,31,211,31,40,31,190,31,7,31,74,31,167,31,136,31,122,31,151,31,183,31,238,31,234,31,234,30,132,31,229,31,191,31,89,31,84,31,93,31,202,31,177,31,177,30,254,31,77,31,240,31,133,31,185,31,215,31,77,31,37,31,37,30,197,31,148,31,194,31,194,30,194,29,125,31,119,31,55,31,157,31,209,31,229,31,12,31,62,31,75,31,159,31,72,31,223,31,6,31,6,30,6,29,6,28,27,31,96,31,193,31,8,31,201,31,92,31,144,31,115,31,197,31,216,31,46,31,79,31,205,31,94,31,139,31,61,31,56,31,141,31,50,31,115,31,10,31,69,31,106,31,160,31,27,31,27,30,22,31,47,31,3,31);

    signal memory_control : std_logic := '0';
    
    constant SCENARIO_ADDRESS : integer := 1234;

    component project_reti_logiche is
        port (
                i_clk : in std_logic;
                i_rst : in std_logic;
                i_start : in std_logic;
                i_add : in std_logic_vector(15 downto 0);
                i_k   : in std_logic_vector(9 downto 0);
                
                o_done : out std_logic;
                
                o_mem_addr : out std_logic_vector(15 downto 0);
                i_mem_data : in  std_logic_vector(7 downto 0);
                o_mem_data : out std_logic_vector(7 downto 0);
                o_mem_we   : out std_logic;
                o_mem_en   : out std_logic
        );
    end component project_reti_logiche;

begin
    UUT : project_reti_logiche
    port map(
                i_clk   => tb_clk,
                i_rst   => tb_rst,
                i_start => tb_start,
                i_add   => tb_add,
                i_k     => tb_k,
                
                o_done => tb_done,
                
                o_mem_addr => exc_o_mem_addr,
                i_mem_data => tb_i_mem_data,
                o_mem_data => exc_o_mem_data,
                o_mem_we   => exc_o_mem_we,
                o_mem_en   => exc_o_mem_en
    );

    -- Clock generation
    tb_clk <= not tb_clk after CLOCK_PERIOD/2;

    -- Process related to the memory
    MEM : process (tb_clk)
    begin
        if tb_clk'event and tb_clk = '1' then
            if tb_o_mem_en = '1' then
                if tb_o_mem_we = '1' then
                    RAM(to_integer(unsigned(tb_o_mem_addr))) <= tb_o_mem_data after 1 ns;
                    tb_i_mem_data <= tb_o_mem_data after 1 ns;
                else
                    tb_i_mem_data <= RAM(to_integer(unsigned(tb_o_mem_addr))) after 1 ns;
                end if;
            end if;
        end if;
    end process;
    
    memory_signal_swapper : process(memory_control, init_o_mem_addr, init_o_mem_data,
                                    init_o_mem_en,  init_o_mem_we,   exc_o_mem_addr,
                                    exc_o_mem_data, exc_o_mem_en, exc_o_mem_we)
    begin
        -- This is necessary for the testbench to work: we swap the memory
        -- signals from the component to the testbench when needed.
    
        tb_o_mem_addr <= init_o_mem_addr;
        tb_o_mem_data <= init_o_mem_data;
        tb_o_mem_en   <= init_o_mem_en;
        tb_o_mem_we   <= init_o_mem_we;

        if memory_control = '1' then
            tb_o_mem_addr <= exc_o_mem_addr;
            tb_o_mem_data <= exc_o_mem_data;
            tb_o_mem_en   <= exc_o_mem_en;
            tb_o_mem_we   <= exc_o_mem_we;
        end if;
    end process;
    
    -- This process provides the correct scenario on the signal controlled by the TB
    create_scenario : process
    begin
        wait for 50 ns;

        -- Signal initialization and reset of the component
        tb_start <= '0';
        tb_add <= (others=>'0');
        tb_k   <= (others=>'0');
        tb_rst <= '1';
        
        -- Wait some time for the component to reset...
        wait for 50 ns;
        
        tb_rst <= '0';
        memory_control <= '0';  -- Memory controlled by the testbench
        
        wait until falling_edge(tb_clk); -- Skew the testbench transitions with respect to the clock

        -- Configure the memory        
        for i in 0 to SCENARIO_LENGTH*2-1 loop
            init_o_mem_addr<= std_logic_vector(to_unsigned(SCENARIO_ADDRESS+i, 16));
            init_o_mem_data<= std_logic_vector(to_unsigned(scenario_input(i),8));
            init_o_mem_en  <= '1';
            init_o_mem_we  <= '1';
            wait until rising_edge(tb_clk);   
        end loop;
        
        wait until falling_edge(tb_clk);

        memory_control <= '1';  -- Memory controlled by the component
        
        tb_add <= std_logic_vector(to_unsigned(SCENARIO_ADDRESS, 16));
        tb_k   <= std_logic_vector(to_unsigned(SCENARIO_LENGTH, 10));
        
        tb_start <= '1';

        while tb_done /= '1' loop                
            wait until rising_edge(tb_clk);
        end loop;

        wait for 5 ns;
        
        tb_start <= '0';
        
        wait;
        
    end process;

    -- Process without sensitivity list designed to test the actual component.
    test_routine : process
    begin

        wait until tb_rst = '1';
        wait for 25 ns;
        assert tb_done = '0' report "TEST FALLITO o_done !=0 during reset" severity failure;
        wait until tb_rst = '0';

        wait until falling_edge(tb_clk);
        assert tb_done = '0' report "TEST FALLITO o_done !=0 after reset before start" severity failure;
        
        wait until rising_edge(tb_start);

        while tb_done /= '1' loop                
            wait until rising_edge(tb_clk);
        end loop;

        assert tb_o_mem_en = '0' or tb_o_mem_we = '0' report "TEST FALLITO o_mem_en !=0 memory should not be written after done." severity failure;

        for i in 0 to SCENARIO_LENGTH*2-1 loop
            assert RAM(SCENARIO_ADDRESS+i) = std_logic_vector(to_unsigned(scenario_full(i),8)) report "TEST FALLITO @ OFFSET=" & integer'image(i) & " expected= " & integer'image(scenario_full(i)) & " actual=" & integer'image(to_integer(unsigned(RAM(i)))) severity failure;
        end loop;

        wait until falling_edge(tb_start);
        assert tb_done = '1' report "TEST FALLITO o_done !=0 after reset before start" severity failure;
        wait until falling_edge(tb_done);

        assert false report "Simulation Ended! TEST PASSATO (EXAMPLE)" severity failure;
    end process;

end architecture;
