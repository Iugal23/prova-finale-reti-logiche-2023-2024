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

constant SCENARIO_LENGTH : integer := 547;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (165,0,129,0,65,0,0,0,213,0,2,0,0,0,94,0,244,0,76,0,49,0,0,0,37,0,0,0,97,0,123,0,218,0,127,0,0,0,0,0,0,0,187,0,81,0,103,0,21,0,108,0,33,0,226,0,200,0,129,0,227,0,76,0,202,0,210,0,98,0,0,0,242,0,140,0,235,0,0,0,0,0,34,0,0,0,61,0,0,0,210,0,0,0,230,0,83,0,164,0,190,0,43,0,232,0,223,0,208,0,235,0,134,0,199,0,254,0,63,0,243,0,0,0,193,0,245,0,163,0,0,0,0,0,0,0,119,0,31,0,53,0,203,0,0,0,158,0,0,0,0,0,157,0,126,0,69,0,104,0,0,0,135,0,68,0,32,0,241,0,87,0,249,0,196,0,54,0,35,0,96,0,85,0,227,0,38,0,121,0,203,0,172,0,229,0,15,0,216,0,110,0,0,0,150,0,57,0,169,0,0,0,60,0,0,0,33,0,195,0,38,0,0,0,218,0,198,0,0,0,55,0,39,0,16,0,0,0,0,0,32,0,239,0,227,0,119,0,218,0,196,0,156,0,180,0,103,0,120,0,193,0,75,0,198,0,113,0,0,0,0,0,93,0,252,0,235,0,245,0,79,0,197,0,0,0,93,0,29,0,126,0,163,0,207,0,78,0,0,0,120,0,203,0,35,0,3,0,100,0,30,0,198,0,178,0,0,0,0,0,0,0,17,0,78,0,0,0,224,0,77,0,242,0,0,0,120,0,246,0,0,0,0,0,0,0,254,0,158,0,0,0,0,0,18,0,187,0,35,0,48,0,6,0,142,0,243,0,182,0,1,0,231,0,136,0,11,0,179,0,205,0,0,0,114,0,61,0,0,0,236,0,124,0,72,0,23,0,177,0,0,0,219,0,225,0,153,0,224,0,0,0,104,0,246,0,99,0,0,0,224,0,160,0,0,0,43,0,78,0,2,0,129,0,0,0,206,0,95,0,0,0,161,0,0,0,178,0,92,0,65,0,101,0,0,0,208,0,176,0,141,0,224,0,73,0,71,0,0,0,204,0,0,0,0,0,150,0,139,0,15,0,235,0,66,0,106,0,0,0,65,0,115,0,124,0,228,0,0,0,194,0,227,0,0,0,0,0,117,0,176,0,211,0,0,0,0,0,119,0,69,0,1,0,12,0,16,0,56,0,87,0,196,0,201,0,88,0,21,0,0,0,250,0,230,0,116,0,0,0,0,0,237,0,171,0,204,0,104,0,244,0,0,0,244,0,235,0,96,0,58,0,247,0,0,0,36,0,216,0,0,0,239,0,179,0,0,0,120,0,190,0,152,0,75,0,16,0,225,0,199,0,206,0,0,0,96,0,227,0,251,0,197,0,88,0,6,0,60,0,47,0,0,0,17,0,40,0,0,0,51,0,139,0,6,0,223,0,0,0,88,0,154,0,17,0,0,0,0,0,14,0,0,0,113,0,248,0,24,0,184,0,33,0,192,0,227,0,67,0,216,0,192,0,0,0,5,0,187,0,144,0,249,0,100,0,72,0,28,0,253,0,64,0,14,0,56,0,128,0,72,0,229,0,100,0,92,0,64,0,75,0,105,0,24,0,0,0,226,0,70,0,131,0,210,0,110,0,49,0,102,0,73,0,194,0,231,0,113,0,27,0,0,0,0,0,5,0,102,0,175,0,0,0,109,0,233,0,93,0,66,0,109,0,108,0,43,0,157,0,178,0,111,0,64,0,134,0,0,0,231,0,73,0,186,0,233,0,252,0,0,0,210,0,12,0,193,0,124,0,200,0,61,0,6,0,231,0,81,0,0,0,19,0,142,0,0,0,255,0,0,0,131,0,0,0,21,0,174,0,136,0,251,0,0,0,232,0,194,0,0,0,66,0,44,0,79,0,242,0,0,0,239,0,1,0,66,0,0,0,228,0,116,0,58,0,238,0,237,0,24,0,195,0,125,0,218,0,148,0,251,0,0,0,0,0,58,0,197,0,255,0,20,0,223,0,51,0,106,0,137,0,121,0,39,0,52,0,40,0,78,0,128,0,134,0,127,0,0,0,83,0,108,0,12,0,249,0,59,0,84,0,0,0,151,0,219,0,61,0,57,0,30,0,0,0,134,0,251,0,154,0,33,0,91,0,177,0,88,0,183,0,130,0,174,0,0,0,150,0,134,0,20,0,221,0,38,0,57,0,24,0,105,0,101,0,72,0,223,0,158,0,39,0,237,0,213,0,135,0,88,0,113,0,0,0,180,0,215,0,103,0,11,0,66,0,0,0,78,0,1,0,112,0,36,0,236,0,108,0,65,0,133,0,72,0,86,0,0,0,29,0,38,0,145,0,232,0,184,0,214,0,196,0,50,0,215,0,17,0,154,0,0,0,0,0,97,0,89,0,88,0,0,0,218,0,210,0,0,0,21,0,220,0,216,0,236,0,0,0,211,0,36,0);
signal scenario_full  : scenario_type := (165,31,129,31,65,31,65,30,213,31,2,31,2,30,94,31,244,31,76,31,49,31,49,30,37,31,37,30,97,31,123,31,218,31,127,31,127,30,127,29,127,28,187,31,81,31,103,31,21,31,108,31,33,31,226,31,200,31,129,31,227,31,76,31,202,31,210,31,98,31,98,30,242,31,140,31,235,31,235,30,235,29,34,31,34,30,61,31,61,30,210,31,210,30,230,31,83,31,164,31,190,31,43,31,232,31,223,31,208,31,235,31,134,31,199,31,254,31,63,31,243,31,243,30,193,31,245,31,163,31,163,30,163,29,163,28,119,31,31,31,53,31,203,31,203,30,158,31,158,30,158,29,157,31,126,31,69,31,104,31,104,30,135,31,68,31,32,31,241,31,87,31,249,31,196,31,54,31,35,31,96,31,85,31,227,31,38,31,121,31,203,31,172,31,229,31,15,31,216,31,110,31,110,30,150,31,57,31,169,31,169,30,60,31,60,30,33,31,195,31,38,31,38,30,218,31,198,31,198,30,55,31,39,31,16,31,16,30,16,29,32,31,239,31,227,31,119,31,218,31,196,31,156,31,180,31,103,31,120,31,193,31,75,31,198,31,113,31,113,30,113,29,93,31,252,31,235,31,245,31,79,31,197,31,197,30,93,31,29,31,126,31,163,31,207,31,78,31,78,30,120,31,203,31,35,31,3,31,100,31,30,31,198,31,178,31,178,30,178,29,178,28,17,31,78,31,78,30,224,31,77,31,242,31,242,30,120,31,246,31,246,30,246,29,246,28,254,31,158,31,158,30,158,29,18,31,187,31,35,31,48,31,6,31,142,31,243,31,182,31,1,31,231,31,136,31,11,31,179,31,205,31,205,30,114,31,61,31,61,30,236,31,124,31,72,31,23,31,177,31,177,30,219,31,225,31,153,31,224,31,224,30,104,31,246,31,99,31,99,30,224,31,160,31,160,30,43,31,78,31,2,31,129,31,129,30,206,31,95,31,95,30,161,31,161,30,178,31,92,31,65,31,101,31,101,30,208,31,176,31,141,31,224,31,73,31,71,31,71,30,204,31,204,30,204,29,150,31,139,31,15,31,235,31,66,31,106,31,106,30,65,31,115,31,124,31,228,31,228,30,194,31,227,31,227,30,227,29,117,31,176,31,211,31,211,30,211,29,119,31,69,31,1,31,12,31,16,31,56,31,87,31,196,31,201,31,88,31,21,31,21,30,250,31,230,31,116,31,116,30,116,29,237,31,171,31,204,31,104,31,244,31,244,30,244,31,235,31,96,31,58,31,247,31,247,30,36,31,216,31,216,30,239,31,179,31,179,30,120,31,190,31,152,31,75,31,16,31,225,31,199,31,206,31,206,30,96,31,227,31,251,31,197,31,88,31,6,31,60,31,47,31,47,30,17,31,40,31,40,30,51,31,139,31,6,31,223,31,223,30,88,31,154,31,17,31,17,30,17,29,14,31,14,30,113,31,248,31,24,31,184,31,33,31,192,31,227,31,67,31,216,31,192,31,192,30,5,31,187,31,144,31,249,31,100,31,72,31,28,31,253,31,64,31,14,31,56,31,128,31,72,31,229,31,100,31,92,31,64,31,75,31,105,31,24,31,24,30,226,31,70,31,131,31,210,31,110,31,49,31,102,31,73,31,194,31,231,31,113,31,27,31,27,30,27,29,5,31,102,31,175,31,175,30,109,31,233,31,93,31,66,31,109,31,108,31,43,31,157,31,178,31,111,31,64,31,134,31,134,30,231,31,73,31,186,31,233,31,252,31,252,30,210,31,12,31,193,31,124,31,200,31,61,31,6,31,231,31,81,31,81,30,19,31,142,31,142,30,255,31,255,30,131,31,131,30,21,31,174,31,136,31,251,31,251,30,232,31,194,31,194,30,66,31,44,31,79,31,242,31,242,30,239,31,1,31,66,31,66,30,228,31,116,31,58,31,238,31,237,31,24,31,195,31,125,31,218,31,148,31,251,31,251,30,251,29,58,31,197,31,255,31,20,31,223,31,51,31,106,31,137,31,121,31,39,31,52,31,40,31,78,31,128,31,134,31,127,31,127,30,83,31,108,31,12,31,249,31,59,31,84,31,84,30,151,31,219,31,61,31,57,31,30,31,30,30,134,31,251,31,154,31,33,31,91,31,177,31,88,31,183,31,130,31,174,31,174,30,150,31,134,31,20,31,221,31,38,31,57,31,24,31,105,31,101,31,72,31,223,31,158,31,39,31,237,31,213,31,135,31,88,31,113,31,113,30,180,31,215,31,103,31,11,31,66,31,66,30,78,31,1,31,112,31,36,31,236,31,108,31,65,31,133,31,72,31,86,31,86,30,29,31,38,31,145,31,232,31,184,31,214,31,196,31,50,31,215,31,17,31,154,31,154,30,154,29,97,31,89,31,88,31,88,30,218,31,210,31,210,30,21,31,220,31,216,31,236,31,236,30,211,31,36,31);

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
