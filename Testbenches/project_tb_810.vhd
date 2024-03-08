-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_810 is
end project_tb_810;

architecture project_tb_arch_810 of project_tb_810 is
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

constant SCENARIO_LENGTH : integer := 597;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (139,0,73,0,90,0,19,0,156,0,195,0,45,0,104,0,0,0,225,0,229,0,0,0,0,0,173,0,233,0,0,0,174,0,143,0,0,0,235,0,190,0,131,0,238,0,213,0,137,0,224,0,0,0,29,0,93,0,4,0,113,0,188,0,254,0,226,0,0,0,220,0,216,0,0,0,125,0,135,0,148,0,0,0,238,0,80,0,20,0,193,0,0,0,0,0,118,0,167,0,0,0,166,0,151,0,137,0,119,0,225,0,43,0,213,0,132,0,177,0,209,0,229,0,50,0,147,0,221,0,150,0,0,0,67,0,249,0,0,0,36,0,168,0,245,0,72,0,104,0,0,0,47,0,224,0,0,0,0,0,0,0,199,0,180,0,211,0,39,0,0,0,146,0,121,0,89,0,235,0,236,0,181,0,32,0,89,0,30,0,0,0,254,0,0,0,210,0,126,0,222,0,246,0,210,0,148,0,245,0,127,0,0,0,14,0,142,0,21,0,224,0,59,0,0,0,86,0,23,0,161,0,92,0,210,0,0,0,133,0,5,0,68,0,194,0,202,0,50,0,177,0,0,0,145,0,59,0,219,0,67,0,98,0,94,0,59,0,0,0,0,0,0,0,86,0,240,0,0,0,0,0,198,0,186,0,139,0,13,0,0,0,253,0,141,0,13,0,47,0,139,0,24,0,255,0,187,0,8,0,244,0,0,0,204,0,129,0,79,0,0,0,176,0,0,0,160,0,120,0,0,0,248,0,28,0,92,0,6,0,0,0,239,0,0,0,251,0,0,0,119,0,21,0,36,0,71,0,183,0,44,0,6,0,206,0,87,0,33,0,243,0,77,0,0,0,78,0,39,0,0,0,33,0,8,0,0,0,0,0,91,0,41,0,4,0,0,0,10,0,227,0,55,0,0,0,0,0,0,0,106,0,240,0,168,0,184,0,21,0,22,0,224,0,194,0,89,0,136,0,96,0,195,0,0,0,0,0,28,0,174,0,217,0,81,0,147,0,147,0,129,0,79,0,20,0,0,0,135,0,122,0,52,0,29,0,191,0,10,0,168,0,157,0,218,0,42,0,2,0,0,0,190,0,196,0,0,0,147,0,14,0,125,0,2,0,0,0,0,0,0,0,173,0,26,0,35,0,0,0,144,0,139,0,0,0,109,0,111,0,0,0,178,0,8,0,0,0,0,0,235,0,23,0,87,0,247,0,106,0,0,0,144,0,77,0,0,0,118,0,111,0,104,0,187,0,82,0,247,0,164,0,150,0,136,0,55,0,151,0,95,0,184,0,192,0,119,0,0,0,169,0,131,0,178,0,179,0,124,0,78,0,2,0,168,0,165,0,166,0,98,0,233,0,0,0,2,0,89,0,178,0,147,0,30,0,140,0,244,0,204,0,41,0,44,0,64,0,98,0,159,0,189,0,41,0,43,0,0,0,0,0,94,0,43,0,207,0,185,0,117,0,88,0,218,0,30,0,173,0,0,0,255,0,208,0,89,0,38,0,48,0,85,0,0,0,37,0,185,0,0,0,0,0,245,0,151,0,37,0,0,0,181,0,3,0,10,0,131,0,152,0,155,0,77,0,105,0,100,0,165,0,158,0,155,0,24,0,241,0,0,0,111,0,190,0,194,0,96,0,119,0,0,0,224,0,6,0,0,0,39,0,26,0,176,0,211,0,203,0,0,0,40,0,0,0,36,0,150,0,50,0,77,0,3,0,76,0,0,0,250,0,127,0,130,0,35,0,113,0,0,0,109,0,88,0,80,0,144,0,142,0,6,0,92,0,242,0,7,0,186,0,104,0,104,0,250,0,187,0,216,0,0,0,26,0,0,0,0,0,21,0,186,0,222,0,109,0,0,0,245,0,7,0,100,0,0,0,156,0,16,0,0,0,119,0,88,0,20,0,31,0,160,0,116,0,57,0,200,0,12,0,176,0,188,0,138,0,0,0,21,0,195,0,118,0,221,0,48,0,115,0,92,0,130,0,0,0,0,0,221,0,223,0,81,0,77,0,84,0,131,0,0,0,0,0,0,0,0,0,21,0,164,0,40,0,44,0,0,0,0,0,202,0,42,0,12,0,77,0,206,0,236,0,10,0,138,0,0,0,221,0,113,0,30,0,31,0,0,0,0,0,5,0,184,0,189,0,147,0,0,0,8,0,0,0,0,0,242,0,216,0,128,0,37,0,30,0,209,0,162,0,145,0,204,0,14,0,160,0,41,0,0,0,209,0,245,0,23,0,179,0,6,0,159,0,4,0,164,0,124,0,0,0,18,0,0,0,15,0,72,0,0,0,120,0,121,0,131,0,164,0,0,0,255,0,116,0,1,0,120,0,0,0,36,0,0,0,0,0,160,0,109,0,192,0,12,0,3,0,71,0,253,0,218,0,55,0,66,0,55,0,11,0,192,0,128,0,79,0,50,0,0,0,139,0,81,0,235,0,63,0,170,0,0,0,31,0,51,0,50,0,239,0,252,0,30,0,232,0,218,0,170,0,226,0,86,0,180,0,159,0,30,0,152,0,0,0,91,0,0,0,0,0,183,0,142,0,250,0,167,0,57,0,46,0,57,0,172,0,69,0,51,0,243,0,251,0,205,0,17,0,23,0,126,0,255,0,184,0,14,0,0,0,177,0,0,0,150,0,218,0,207,0,187,0,0,0,179,0,30,0,193,0);
signal scenario_full  : scenario_type := (139,31,73,31,90,31,19,31,156,31,195,31,45,31,104,31,104,30,225,31,229,31,229,30,229,29,173,31,233,31,233,30,174,31,143,31,143,30,235,31,190,31,131,31,238,31,213,31,137,31,224,31,224,30,29,31,93,31,4,31,113,31,188,31,254,31,226,31,226,30,220,31,216,31,216,30,125,31,135,31,148,31,148,30,238,31,80,31,20,31,193,31,193,30,193,29,118,31,167,31,167,30,166,31,151,31,137,31,119,31,225,31,43,31,213,31,132,31,177,31,209,31,229,31,50,31,147,31,221,31,150,31,150,30,67,31,249,31,249,30,36,31,168,31,245,31,72,31,104,31,104,30,47,31,224,31,224,30,224,29,224,28,199,31,180,31,211,31,39,31,39,30,146,31,121,31,89,31,235,31,236,31,181,31,32,31,89,31,30,31,30,30,254,31,254,30,210,31,126,31,222,31,246,31,210,31,148,31,245,31,127,31,127,30,14,31,142,31,21,31,224,31,59,31,59,30,86,31,23,31,161,31,92,31,210,31,210,30,133,31,5,31,68,31,194,31,202,31,50,31,177,31,177,30,145,31,59,31,219,31,67,31,98,31,94,31,59,31,59,30,59,29,59,28,86,31,240,31,240,30,240,29,198,31,186,31,139,31,13,31,13,30,253,31,141,31,13,31,47,31,139,31,24,31,255,31,187,31,8,31,244,31,244,30,204,31,129,31,79,31,79,30,176,31,176,30,160,31,120,31,120,30,248,31,28,31,92,31,6,31,6,30,239,31,239,30,251,31,251,30,119,31,21,31,36,31,71,31,183,31,44,31,6,31,206,31,87,31,33,31,243,31,77,31,77,30,78,31,39,31,39,30,33,31,8,31,8,30,8,29,91,31,41,31,4,31,4,30,10,31,227,31,55,31,55,30,55,29,55,28,106,31,240,31,168,31,184,31,21,31,22,31,224,31,194,31,89,31,136,31,96,31,195,31,195,30,195,29,28,31,174,31,217,31,81,31,147,31,147,31,129,31,79,31,20,31,20,30,135,31,122,31,52,31,29,31,191,31,10,31,168,31,157,31,218,31,42,31,2,31,2,30,190,31,196,31,196,30,147,31,14,31,125,31,2,31,2,30,2,29,2,28,173,31,26,31,35,31,35,30,144,31,139,31,139,30,109,31,111,31,111,30,178,31,8,31,8,30,8,29,235,31,23,31,87,31,247,31,106,31,106,30,144,31,77,31,77,30,118,31,111,31,104,31,187,31,82,31,247,31,164,31,150,31,136,31,55,31,151,31,95,31,184,31,192,31,119,31,119,30,169,31,131,31,178,31,179,31,124,31,78,31,2,31,168,31,165,31,166,31,98,31,233,31,233,30,2,31,89,31,178,31,147,31,30,31,140,31,244,31,204,31,41,31,44,31,64,31,98,31,159,31,189,31,41,31,43,31,43,30,43,29,94,31,43,31,207,31,185,31,117,31,88,31,218,31,30,31,173,31,173,30,255,31,208,31,89,31,38,31,48,31,85,31,85,30,37,31,185,31,185,30,185,29,245,31,151,31,37,31,37,30,181,31,3,31,10,31,131,31,152,31,155,31,77,31,105,31,100,31,165,31,158,31,155,31,24,31,241,31,241,30,111,31,190,31,194,31,96,31,119,31,119,30,224,31,6,31,6,30,39,31,26,31,176,31,211,31,203,31,203,30,40,31,40,30,36,31,150,31,50,31,77,31,3,31,76,31,76,30,250,31,127,31,130,31,35,31,113,31,113,30,109,31,88,31,80,31,144,31,142,31,6,31,92,31,242,31,7,31,186,31,104,31,104,31,250,31,187,31,216,31,216,30,26,31,26,30,26,29,21,31,186,31,222,31,109,31,109,30,245,31,7,31,100,31,100,30,156,31,16,31,16,30,119,31,88,31,20,31,31,31,160,31,116,31,57,31,200,31,12,31,176,31,188,31,138,31,138,30,21,31,195,31,118,31,221,31,48,31,115,31,92,31,130,31,130,30,130,29,221,31,223,31,81,31,77,31,84,31,131,31,131,30,131,29,131,28,131,27,21,31,164,31,40,31,44,31,44,30,44,29,202,31,42,31,12,31,77,31,206,31,236,31,10,31,138,31,138,30,221,31,113,31,30,31,31,31,31,30,31,29,5,31,184,31,189,31,147,31,147,30,8,31,8,30,8,29,242,31,216,31,128,31,37,31,30,31,209,31,162,31,145,31,204,31,14,31,160,31,41,31,41,30,209,31,245,31,23,31,179,31,6,31,159,31,4,31,164,31,124,31,124,30,18,31,18,30,15,31,72,31,72,30,120,31,121,31,131,31,164,31,164,30,255,31,116,31,1,31,120,31,120,30,36,31,36,30,36,29,160,31,109,31,192,31,12,31,3,31,71,31,253,31,218,31,55,31,66,31,55,31,11,31,192,31,128,31,79,31,50,31,50,30,139,31,81,31,235,31,63,31,170,31,170,30,31,31,51,31,50,31,239,31,252,31,30,31,232,31,218,31,170,31,226,31,86,31,180,31,159,31,30,31,152,31,152,30,91,31,91,30,91,29,183,31,142,31,250,31,167,31,57,31,46,31,57,31,172,31,69,31,51,31,243,31,251,31,205,31,17,31,23,31,126,31,255,31,184,31,14,31,14,30,177,31,177,30,150,31,218,31,207,31,187,31,187,30,179,31,30,31,193,31);

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
