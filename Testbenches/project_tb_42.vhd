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

constant SCENARIO_LENGTH : integer := 590;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (114,0,0,0,14,0,102,0,34,0,227,0,76,0,111,0,104,0,0,0,207,0,244,0,23,0,168,0,178,0,171,0,106,0,147,0,136,0,1,0,190,0,152,0,134,0,37,0,103,0,183,0,102,0,75,0,90,0,234,0,222,0,5,0,82,0,0,0,216,0,11,0,201,0,0,0,203,0,0,0,210,0,120,0,74,0,201,0,90,0,180,0,76,0,64,0,234,0,158,0,144,0,5,0,78,0,116,0,117,0,0,0,240,0,0,0,0,0,161,0,0,0,244,0,0,0,113,0,0,0,159,0,105,0,0,0,0,0,115,0,209,0,39,0,0,0,165,0,152,0,123,0,234,0,0,0,199,0,229,0,148,0,109,0,151,0,146,0,49,0,0,0,216,0,102,0,192,0,148,0,231,0,0,0,45,0,158,0,130,0,199,0,70,0,216,0,0,0,0,0,197,0,94,0,4,0,19,0,0,0,158,0,12,0,241,0,0,0,0,0,27,0,22,0,0,0,189,0,71,0,197,0,223,0,83,0,83,0,98,0,172,0,0,0,0,0,218,0,139,0,94,0,199,0,233,0,170,0,163,0,0,0,226,0,213,0,135,0,0,0,202,0,0,0,83,0,147,0,32,0,234,0,0,0,213,0,80,0,0,0,19,0,247,0,142,0,0,0,3,0,211,0,142,0,0,0,166,0,0,0,71,0,0,0,21,0,0,0,68,0,96,0,245,0,0,0,84,0,10,0,167,0,163,0,28,0,44,0,126,0,239,0,41,0,187,0,202,0,185,0,207,0,57,0,14,0,23,0,0,0,0,0,117,0,0,0,100,0,227,0,84,0,253,0,0,0,44,0,152,0,219,0,229,0,193,0,0,0,0,0,95,0,94,0,131,0,201,0,5,0,131,0,92,0,0,0,25,0,36,0,71,0,0,0,109,0,221,0,0,0,0,0,12,0,221,0,15,0,0,0,220,0,214,0,60,0,176,0,50,0,109,0,0,0,176,0,104,0,86,0,159,0,185,0,192,0,172,0,0,0,0,0,91,0,160,0,76,0,74,0,63,0,93,0,165,0,0,0,0,0,0,0,0,0,22,0,175,0,159,0,0,0,239,0,0,0,145,0,0,0,150,0,129,0,0,0,92,0,0,0,68,0,0,0,135,0,214,0,167,0,68,0,42,0,0,0,89,0,167,0,53,0,129,0,0,0,223,0,134,0,1,0,99,0,128,0,230,0,215,0,17,0,191,0,137,0,0,0,28,0,190,0,27,0,0,0,174,0,0,0,0,0,0,0,0,0,137,0,157,0,235,0,31,0,196,0,249,0,234,0,12,0,149,0,76,0,88,0,0,0,163,0,26,0,163,0,0,0,17,0,250,0,48,0,12,0,79,0,0,0,86,0,29,0,19,0,242,0,173,0,219,0,154,0,0,0,230,0,9,0,120,0,177,0,0,0,122,0,101,0,225,0,251,0,0,0,10,0,71,0,0,0,155,0,0,0,0,0,137,0,0,0,177,0,0,0,251,0,112,0,245,0,93,0,25,0,241,0,171,0,0,0,81,0,33,0,59,0,164,0,0,0,228,0,0,0,48,0,0,0,0,0,155,0,38,0,150,0,0,0,221,0,201,0,0,0,142,0,181,0,57,0,0,0,0,0,49,0,232,0,0,0,245,0,129,0,139,0,0,0,206,0,213,0,20,0,4,0,0,0,150,0,0,0,0,0,199,0,137,0,248,0,146,0,57,0,82,0,244,0,58,0,53,0,181,0,136,0,90,0,133,0,0,0,72,0,8,0,57,0,0,0,128,0,227,0,4,0,2,0,0,0,209,0,148,0,107,0,0,0,188,0,106,0,59,0,139,0,144,0,0,0,86,0,142,0,119,0,118,0,102,0,0,0,186,0,194,0,4,0,8,0,86,0,157,0,18,0,111,0,212,0,0,0,104,0,167,0,198,0,52,0,0,0,0,0,0,0,0,0,26,0,0,0,120,0,121,0,0,0,50,0,207,0,0,0,0,0,0,0,152,0,204,0,0,0,158,0,0,0,176,0,0,0,233,0,0,0,1,0,229,0,6,0,0,0,203,0,1,0,105,0,69,0,81,0,135,0,105,0,0,0,9,0,0,0,26,0,134,0,51,0,45,0,80,0,47,0,35,0,93,0,2,0,143,0,31,0,123,0,24,0,190,0,177,0,0,0,0,0,31,0,15,0,26,0,39,0,60,0,0,0,121,0,90,0,54,0,184,0,116,0,77,0,0,0,210,0,40,0,151,0,0,0,88,0,133,0,91,0,228,0,0,0,0,0,97,0,33,0,11,0,172,0,167,0,0,0,36,0,221,0,151,0,135,0,189,0,172,0,16,0,178,0,190,0,115,0,99,0,37,0,0,0,150,0,151,0,114,0,253,0,207,0,145,0,141,0,218,0,253,0,0,0,0,0,30,0,21,0,0,0,0,0,66,0,246,0,200,0,191,0,101,0,0,0,219,0,247,0,0,0,177,0,254,0,123,0,0,0,88,0,175,0,0,0,9,0,0,0,239,0,0,0,165,0,0,0,104,0,65,0,160,0,236,0,170,0,62,0,27,0,0,0,250,0,101,0,220,0,0,0,223,0,228,0,0,0,61,0,228,0,229,0,171,0,156,0,0,0);
signal scenario_full  : scenario_type := (114,31,114,30,14,31,102,31,34,31,227,31,76,31,111,31,104,31,104,30,207,31,244,31,23,31,168,31,178,31,171,31,106,31,147,31,136,31,1,31,190,31,152,31,134,31,37,31,103,31,183,31,102,31,75,31,90,31,234,31,222,31,5,31,82,31,82,30,216,31,11,31,201,31,201,30,203,31,203,30,210,31,120,31,74,31,201,31,90,31,180,31,76,31,64,31,234,31,158,31,144,31,5,31,78,31,116,31,117,31,117,30,240,31,240,30,240,29,161,31,161,30,244,31,244,30,113,31,113,30,159,31,105,31,105,30,105,29,115,31,209,31,39,31,39,30,165,31,152,31,123,31,234,31,234,30,199,31,229,31,148,31,109,31,151,31,146,31,49,31,49,30,216,31,102,31,192,31,148,31,231,31,231,30,45,31,158,31,130,31,199,31,70,31,216,31,216,30,216,29,197,31,94,31,4,31,19,31,19,30,158,31,12,31,241,31,241,30,241,29,27,31,22,31,22,30,189,31,71,31,197,31,223,31,83,31,83,31,98,31,172,31,172,30,172,29,218,31,139,31,94,31,199,31,233,31,170,31,163,31,163,30,226,31,213,31,135,31,135,30,202,31,202,30,83,31,147,31,32,31,234,31,234,30,213,31,80,31,80,30,19,31,247,31,142,31,142,30,3,31,211,31,142,31,142,30,166,31,166,30,71,31,71,30,21,31,21,30,68,31,96,31,245,31,245,30,84,31,10,31,167,31,163,31,28,31,44,31,126,31,239,31,41,31,187,31,202,31,185,31,207,31,57,31,14,31,23,31,23,30,23,29,117,31,117,30,100,31,227,31,84,31,253,31,253,30,44,31,152,31,219,31,229,31,193,31,193,30,193,29,95,31,94,31,131,31,201,31,5,31,131,31,92,31,92,30,25,31,36,31,71,31,71,30,109,31,221,31,221,30,221,29,12,31,221,31,15,31,15,30,220,31,214,31,60,31,176,31,50,31,109,31,109,30,176,31,104,31,86,31,159,31,185,31,192,31,172,31,172,30,172,29,91,31,160,31,76,31,74,31,63,31,93,31,165,31,165,30,165,29,165,28,165,27,22,31,175,31,159,31,159,30,239,31,239,30,145,31,145,30,150,31,129,31,129,30,92,31,92,30,68,31,68,30,135,31,214,31,167,31,68,31,42,31,42,30,89,31,167,31,53,31,129,31,129,30,223,31,134,31,1,31,99,31,128,31,230,31,215,31,17,31,191,31,137,31,137,30,28,31,190,31,27,31,27,30,174,31,174,30,174,29,174,28,174,27,137,31,157,31,235,31,31,31,196,31,249,31,234,31,12,31,149,31,76,31,88,31,88,30,163,31,26,31,163,31,163,30,17,31,250,31,48,31,12,31,79,31,79,30,86,31,29,31,19,31,242,31,173,31,219,31,154,31,154,30,230,31,9,31,120,31,177,31,177,30,122,31,101,31,225,31,251,31,251,30,10,31,71,31,71,30,155,31,155,30,155,29,137,31,137,30,177,31,177,30,251,31,112,31,245,31,93,31,25,31,241,31,171,31,171,30,81,31,33,31,59,31,164,31,164,30,228,31,228,30,48,31,48,30,48,29,155,31,38,31,150,31,150,30,221,31,201,31,201,30,142,31,181,31,57,31,57,30,57,29,49,31,232,31,232,30,245,31,129,31,139,31,139,30,206,31,213,31,20,31,4,31,4,30,150,31,150,30,150,29,199,31,137,31,248,31,146,31,57,31,82,31,244,31,58,31,53,31,181,31,136,31,90,31,133,31,133,30,72,31,8,31,57,31,57,30,128,31,227,31,4,31,2,31,2,30,209,31,148,31,107,31,107,30,188,31,106,31,59,31,139,31,144,31,144,30,86,31,142,31,119,31,118,31,102,31,102,30,186,31,194,31,4,31,8,31,86,31,157,31,18,31,111,31,212,31,212,30,104,31,167,31,198,31,52,31,52,30,52,29,52,28,52,27,26,31,26,30,120,31,121,31,121,30,50,31,207,31,207,30,207,29,207,28,152,31,204,31,204,30,158,31,158,30,176,31,176,30,233,31,233,30,1,31,229,31,6,31,6,30,203,31,1,31,105,31,69,31,81,31,135,31,105,31,105,30,9,31,9,30,26,31,134,31,51,31,45,31,80,31,47,31,35,31,93,31,2,31,143,31,31,31,123,31,24,31,190,31,177,31,177,30,177,29,31,31,15,31,26,31,39,31,60,31,60,30,121,31,90,31,54,31,184,31,116,31,77,31,77,30,210,31,40,31,151,31,151,30,88,31,133,31,91,31,228,31,228,30,228,29,97,31,33,31,11,31,172,31,167,31,167,30,36,31,221,31,151,31,135,31,189,31,172,31,16,31,178,31,190,31,115,31,99,31,37,31,37,30,150,31,151,31,114,31,253,31,207,31,145,31,141,31,218,31,253,31,253,30,253,29,30,31,21,31,21,30,21,29,66,31,246,31,200,31,191,31,101,31,101,30,219,31,247,31,247,30,177,31,254,31,123,31,123,30,88,31,175,31,175,30,9,31,9,30,239,31,239,30,165,31,165,30,104,31,65,31,160,31,236,31,170,31,62,31,27,31,27,30,250,31,101,31,220,31,220,30,223,31,228,31,228,30,61,31,228,31,229,31,171,31,156,31,156,30);

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
