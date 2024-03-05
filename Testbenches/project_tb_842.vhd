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

constant SCENARIO_LENGTH : integer := 454;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (0,0,225,0,60,0,73,0,0,0,0,0,206,0,146,0,0,0,0,0,59,0,25,0,221,0,231,0,240,0,240,0,177,0,251,0,70,0,54,0,155,0,56,0,153,0,0,0,16,0,231,0,186,0,235,0,216,0,184,0,2,0,127,0,73,0,85,0,64,0,178,0,147,0,177,0,0,0,9,0,122,0,0,0,13,0,222,0,69,0,56,0,120,0,121,0,230,0,20,0,0,0,194,0,156,0,206,0,30,0,192,0,97,0,0,0,0,0,211,0,189,0,104,0,93,0,215,0,176,0,79,0,87,0,65,0,188,0,188,0,0,0,202,0,81,0,0,0,88,0,0,0,141,0,128,0,23,0,228,0,0,0,0,0,0,0,229,0,122,0,0,0,86,0,160,0,0,0,198,0,180,0,0,0,146,0,255,0,55,0,227,0,158,0,25,0,202,0,122,0,136,0,89,0,0,0,206,0,198,0,232,0,140,0,146,0,28,0,130,0,201,0,5,0,13,0,139,0,10,0,156,0,0,0,250,0,151,0,170,0,136,0,123,0,35,0,147,0,238,0,166,0,67,0,22,0,0,0,247,0,138,0,128,0,104,0,163,0,88,0,46,0,119,0,106,0,79,0,242,0,0,0,194,0,161,0,79,0,0,0,0,0,197,0,150,0,33,0,50,0,7,0,145,0,0,0,0,0,188,0,80,0,97,0,213,0,92,0,110,0,0,0,101,0,86,0,0,0,103,0,60,0,0,0,18,0,228,0,203,0,99,0,102,0,181,0,100,0,0,0,0,0,49,0,45,0,30,0,255,0,175,0,101,0,27,0,143,0,168,0,0,0,196,0,102,0,64,0,0,0,189,0,26,0,176,0,196,0,153,0,143,0,150,0,67,0,63,0,197,0,53,0,0,0,0,0,54,0,233,0,0,0,230,0,0,0,118,0,162,0,0,0,207,0,62,0,91,0,148,0,197,0,136,0,0,0,67,0,96,0,204,0,14,0,71,0,168,0,140,0,83,0,79,0,175,0,81,0,186,0,92,0,31,0,252,0,123,0,0,0,224,0,0,0,15,0,136,0,246,0,186,0,0,0,212,0,221,0,195,0,159,0,26,0,102,0,13,0,0,0,97,0,86,0,175,0,24,0,67,0,245,0,133,0,196,0,161,0,160,0,245,0,129,0,90,0,248,0,138,0,174,0,0,0,144,0,230,0,78,0,0,0,101,0,223,0,106,0,0,0,231,0,229,0,126,0,169,0,97,0,19,0,48,0,0,0,0,0,73,0,75,0,167,0,58,0,109,0,122,0,53,0,0,0,247,0,247,0,48,0,8,0,183,0,0,0,117,0,43,0,98,0,0,0,169,0,166,0,58,0,80,0,67,0,172,0,0,0,248,0,96,0,0,0,0,0,3,0,180,0,91,0,122,0,105,0,16,0,169,0,216,0,178,0,0,0,192,0,52,0,73,0,40,0,218,0,118,0,121,0,0,0,250,0,162,0,97,0,183,0,251,0,251,0,0,0,203,0,21,0,40,0,193,0,106,0,43,0,13,0,25,0,0,0,116,0,234,0,85,0,156,0,0,0,168,0,44,0,95,0,182,0,0,0,4,0,100,0,221,0,0,0,163,0,50,0,238,0,144,0,135,0,0,0,0,0,248,0,233,0,23,0,41,0,122,0,0,0,104,0,129,0,157,0,58,0,0,0,21,0,0,0,199,0,165,0,0,0,140,0,238,0,242,0,130,0,99,0,0,0,64,0,26,0,26,0,76,0,232,0,11,0,237,0,15,0,1,0,67,0,113,0,0,0,12,0,80,0,234,0,34,0,131,0,156,0,214,0,27,0,127,0,251,0,0,0,0,0,0,0,0,0,0,0,72,0,0,0,215,0,19,0,146,0,252,0,46,0,241,0,239,0,150,0,169,0,33,0,0,0,79,0,0,0,210,0,131,0,66,0,92,0,0,0,0,0,52,0,21,0,234,0,108,0,0,0,185,0,0,0,44,0,249,0,0,0,0,0,183,0,208,0,225,0,0,0,97,0);
signal scenario_full  : scenario_type := (0,0,225,31,60,31,73,31,73,30,73,29,206,31,146,31,146,30,146,29,59,31,25,31,221,31,231,31,240,31,240,31,177,31,251,31,70,31,54,31,155,31,56,31,153,31,153,30,16,31,231,31,186,31,235,31,216,31,184,31,2,31,127,31,73,31,85,31,64,31,178,31,147,31,177,31,177,30,9,31,122,31,122,30,13,31,222,31,69,31,56,31,120,31,121,31,230,31,20,31,20,30,194,31,156,31,206,31,30,31,192,31,97,31,97,30,97,29,211,31,189,31,104,31,93,31,215,31,176,31,79,31,87,31,65,31,188,31,188,31,188,30,202,31,81,31,81,30,88,31,88,30,141,31,128,31,23,31,228,31,228,30,228,29,228,28,229,31,122,31,122,30,86,31,160,31,160,30,198,31,180,31,180,30,146,31,255,31,55,31,227,31,158,31,25,31,202,31,122,31,136,31,89,31,89,30,206,31,198,31,232,31,140,31,146,31,28,31,130,31,201,31,5,31,13,31,139,31,10,31,156,31,156,30,250,31,151,31,170,31,136,31,123,31,35,31,147,31,238,31,166,31,67,31,22,31,22,30,247,31,138,31,128,31,104,31,163,31,88,31,46,31,119,31,106,31,79,31,242,31,242,30,194,31,161,31,79,31,79,30,79,29,197,31,150,31,33,31,50,31,7,31,145,31,145,30,145,29,188,31,80,31,97,31,213,31,92,31,110,31,110,30,101,31,86,31,86,30,103,31,60,31,60,30,18,31,228,31,203,31,99,31,102,31,181,31,100,31,100,30,100,29,49,31,45,31,30,31,255,31,175,31,101,31,27,31,143,31,168,31,168,30,196,31,102,31,64,31,64,30,189,31,26,31,176,31,196,31,153,31,143,31,150,31,67,31,63,31,197,31,53,31,53,30,53,29,54,31,233,31,233,30,230,31,230,30,118,31,162,31,162,30,207,31,62,31,91,31,148,31,197,31,136,31,136,30,67,31,96,31,204,31,14,31,71,31,168,31,140,31,83,31,79,31,175,31,81,31,186,31,92,31,31,31,252,31,123,31,123,30,224,31,224,30,15,31,136,31,246,31,186,31,186,30,212,31,221,31,195,31,159,31,26,31,102,31,13,31,13,30,97,31,86,31,175,31,24,31,67,31,245,31,133,31,196,31,161,31,160,31,245,31,129,31,90,31,248,31,138,31,174,31,174,30,144,31,230,31,78,31,78,30,101,31,223,31,106,31,106,30,231,31,229,31,126,31,169,31,97,31,19,31,48,31,48,30,48,29,73,31,75,31,167,31,58,31,109,31,122,31,53,31,53,30,247,31,247,31,48,31,8,31,183,31,183,30,117,31,43,31,98,31,98,30,169,31,166,31,58,31,80,31,67,31,172,31,172,30,248,31,96,31,96,30,96,29,3,31,180,31,91,31,122,31,105,31,16,31,169,31,216,31,178,31,178,30,192,31,52,31,73,31,40,31,218,31,118,31,121,31,121,30,250,31,162,31,97,31,183,31,251,31,251,31,251,30,203,31,21,31,40,31,193,31,106,31,43,31,13,31,25,31,25,30,116,31,234,31,85,31,156,31,156,30,168,31,44,31,95,31,182,31,182,30,4,31,100,31,221,31,221,30,163,31,50,31,238,31,144,31,135,31,135,30,135,29,248,31,233,31,23,31,41,31,122,31,122,30,104,31,129,31,157,31,58,31,58,30,21,31,21,30,199,31,165,31,165,30,140,31,238,31,242,31,130,31,99,31,99,30,64,31,26,31,26,31,76,31,232,31,11,31,237,31,15,31,1,31,67,31,113,31,113,30,12,31,80,31,234,31,34,31,131,31,156,31,214,31,27,31,127,31,251,31,251,30,251,29,251,28,251,27,251,26,72,31,72,30,215,31,19,31,146,31,252,31,46,31,241,31,239,31,150,31,169,31,33,31,33,30,79,31,79,30,210,31,131,31,66,31,92,31,92,30,92,29,52,31,21,31,234,31,108,31,108,30,185,31,185,30,44,31,249,31,249,30,249,29,183,31,208,31,225,31,225,30,97,31);

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
