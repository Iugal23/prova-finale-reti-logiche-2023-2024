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

constant SCENARIO_LENGTH : integer := 274;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (64,0,189,0,182,0,225,0,204,0,223,0,0,0,99,0,165,0,7,0,210,0,0,0,239,0,227,0,0,0,192,0,218,0,8,0,220,0,115,0,88,0,130,0,232,0,33,0,134,0,0,0,64,0,220,0,171,0,43,0,4,0,155,0,201,0,131,0,19,0,114,0,0,0,65,0,0,0,234,0,1,0,38,0,158,0,42,0,49,0,231,0,147,0,160,0,13,0,229,0,0,0,194,0,51,0,0,0,244,0,0,0,234,0,169,0,226,0,51,0,0,0,250,0,57,0,35,0,158,0,89,0,222,0,12,0,0,0,0,0,231,0,80,0,244,0,141,0,11,0,188,0,0,0,89,0,0,0,45,0,121,0,0,0,78,0,244,0,120,0,0,0,155,0,143,0,246,0,168,0,109,0,241,0,219,0,202,0,39,0,245,0,102,0,55,0,0,0,134,0,69,0,172,0,64,0,248,0,234,0,77,0,0,0,175,0,79,0,0,0,86,0,80,0,198,0,201,0,0,0,2,0,97,0,19,0,0,0,141,0,147,0,158,0,224,0,0,0,74,0,0,0,201,0,58,0,91,0,40,0,0,0,252,0,44,0,0,0,140,0,99,0,21,0,156,0,243,0,156,0,232,0,197,0,0,0,0,0,226,0,132,0,107,0,72,0,0,0,78,0,133,0,201,0,49,0,9,0,230,0,161,0,189,0,63,0,122,0,239,0,0,0,0,0,128,0,60,0,82,0,0,0,0,0,100,0,20,0,96,0,204,0,46,0,0,0,248,0,122,0,0,0,178,0,128,0,249,0,5,0,183,0,34,0,64,0,83,0,159,0,245,0,41,0,218,0,76,0,169,0,204,0,101,0,137,0,73,0,0,0,0,0,176,0,20,0,161,0,0,0,92,0,0,0,210,0,192,0,44,0,0,0,107,0,0,0,186,0,4,0,243,0,235,0,19,0,179,0,237,0,214,0,179,0,36,0,207,0,137,0,118,0,67,0,251,0,0,0,215,0,36,0,0,0,183,0,181,0,148,0,10,0,202,0,81,0,85,0,146,0,0,0,53,0,12,0,252,0,0,0,57,0,49,0,240,0,51,0,0,0,0,0,160,0,226,0,0,0,136,0,89,0,186,0,136,0,3,0,159,0,182,0,200,0,0,0,114,0,174,0,0,0,230,0,225,0,226,0,217,0,20,0,251,0,27,0,239,0,131,0,57,0,0,0,246,0,147,0);
signal scenario_full  : scenario_type := (64,31,189,31,182,31,225,31,204,31,223,31,223,30,99,31,165,31,7,31,210,31,210,30,239,31,227,31,227,30,192,31,218,31,8,31,220,31,115,31,88,31,130,31,232,31,33,31,134,31,134,30,64,31,220,31,171,31,43,31,4,31,155,31,201,31,131,31,19,31,114,31,114,30,65,31,65,30,234,31,1,31,38,31,158,31,42,31,49,31,231,31,147,31,160,31,13,31,229,31,229,30,194,31,51,31,51,30,244,31,244,30,234,31,169,31,226,31,51,31,51,30,250,31,57,31,35,31,158,31,89,31,222,31,12,31,12,30,12,29,231,31,80,31,244,31,141,31,11,31,188,31,188,30,89,31,89,30,45,31,121,31,121,30,78,31,244,31,120,31,120,30,155,31,143,31,246,31,168,31,109,31,241,31,219,31,202,31,39,31,245,31,102,31,55,31,55,30,134,31,69,31,172,31,64,31,248,31,234,31,77,31,77,30,175,31,79,31,79,30,86,31,80,31,198,31,201,31,201,30,2,31,97,31,19,31,19,30,141,31,147,31,158,31,224,31,224,30,74,31,74,30,201,31,58,31,91,31,40,31,40,30,252,31,44,31,44,30,140,31,99,31,21,31,156,31,243,31,156,31,232,31,197,31,197,30,197,29,226,31,132,31,107,31,72,31,72,30,78,31,133,31,201,31,49,31,9,31,230,31,161,31,189,31,63,31,122,31,239,31,239,30,239,29,128,31,60,31,82,31,82,30,82,29,100,31,20,31,96,31,204,31,46,31,46,30,248,31,122,31,122,30,178,31,128,31,249,31,5,31,183,31,34,31,64,31,83,31,159,31,245,31,41,31,218,31,76,31,169,31,204,31,101,31,137,31,73,31,73,30,73,29,176,31,20,31,161,31,161,30,92,31,92,30,210,31,192,31,44,31,44,30,107,31,107,30,186,31,4,31,243,31,235,31,19,31,179,31,237,31,214,31,179,31,36,31,207,31,137,31,118,31,67,31,251,31,251,30,215,31,36,31,36,30,183,31,181,31,148,31,10,31,202,31,81,31,85,31,146,31,146,30,53,31,12,31,252,31,252,30,57,31,49,31,240,31,51,31,51,30,51,29,160,31,226,31,226,30,136,31,89,31,186,31,136,31,3,31,159,31,182,31,200,31,200,30,114,31,174,31,174,30,230,31,225,31,226,31,217,31,20,31,251,31,27,31,239,31,131,31,57,31,57,30,246,31,147,31);

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
