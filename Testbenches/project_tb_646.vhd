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

constant SCENARIO_LENGTH : integer := 439;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (53,0,116,0,98,0,201,0,0,0,0,0,111,0,0,0,196,0,161,0,25,0,229,0,0,0,49,0,104,0,0,0,149,0,212,0,0,0,152,0,143,0,163,0,59,0,161,0,0,0,108,0,146,0,67,0,0,0,184,0,50,0,109,0,94,0,229,0,84,0,0,0,243,0,145,0,132,0,211,0,104,0,0,0,0,0,191,0,43,0,28,0,246,0,6,0,249,0,32,0,200,0,202,0,87,0,27,0,67,0,0,0,0,0,200,0,163,0,8,0,201,0,49,0,187,0,0,0,110,0,0,0,125,0,70,0,76,0,249,0,23,0,162,0,237,0,96,0,60,0,0,0,4,0,203,0,230,0,124,0,100,0,199,0,177,0,79,0,155,0,190,0,0,0,85,0,148,0,152,0,3,0,226,0,238,0,48,0,69,0,57,0,0,0,0,0,0,0,176,0,73,0,39,0,124,0,120,0,245,0,153,0,165,0,45,0,85,0,67,0,245,0,0,0,240,0,203,0,193,0,192,0,225,0,186,0,9,0,100,0,205,0,0,0,224,0,89,0,248,0,51,0,6,0,63,0,134,0,6,0,136,0,113,0,207,0,0,0,0,0,1,0,11,0,77,0,143,0,234,0,6,0,38,0,0,0,5,0,196,0,207,0,56,0,0,0,172,0,180,0,217,0,218,0,133,0,36,0,201,0,0,0,189,0,217,0,103,0,27,0,240,0,69,0,56,0,17,0,2,0,62,0,0,0,240,0,108,0,190,0,0,0,76,0,0,0,118,0,242,0,57,0,0,0,228,0,181,0,0,0,192,0,200,0,219,0,0,0,231,0,101,0,118,0,102,0,203,0,129,0,127,0,216,0,75,0,187,0,0,0,0,0,213,0,12,0,161,0,98,0,0,0,186,0,57,0,0,0,249,0,96,0,143,0,162,0,0,0,70,0,179,0,50,0,231,0,225,0,0,0,8,0,38,0,73,0,17,0,17,0,80,0,44,0,161,0,188,0,172,0,176,0,0,0,0,0,138,0,201,0,25,0,53,0,41,0,243,0,9,0,55,0,78,0,105,0,122,0,0,0,186,0,215,0,148,0,75,0,37,0,0,0,88,0,158,0,149,0,61,0,216,0,160,0,237,0,44,0,0,0,141,0,0,0,236,0,68,0,180,0,193,0,21,0,217,0,141,0,81,0,0,0,220,0,33,0,190,0,61,0,166,0,169,0,0,0,0,0,0,0,8,0,31,0,174,0,91,0,127,0,17,0,0,0,134,0,0,0,183,0,59,0,54,0,56,0,0,0,156,0,0,0,201,0,169,0,0,0,0,0,216,0,207,0,1,0,0,0,0,0,68,0,0,0,208,0,0,0,21,0,12,0,153,0,0,0,0,0,0,0,45,0,109,0,107,0,0,0,0,0,155,0,21,0,2,0,237,0,129,0,177,0,175,0,0,0,150,0,16,0,210,0,37,0,0,0,231,0,33,0,195,0,27,0,147,0,154,0,164,0,22,0,230,0,164,0,135,0,204,0,145,0,33,0,0,0,250,0,226,0,118,0,180,0,113,0,49,0,65,0,64,0,201,0,0,0,124,0,134,0,202,0,16,0,0,0,167,0,105,0,0,0,202,0,0,0,88,0,202,0,0,0,0,0,98,0,102,0,108,0,0,0,82,0,222,0,206,0,35,0,245,0,155,0,148,0,152,0,240,0,171,0,0,0,125,0,238,0,0,0,0,0,7,0,43,0,221,0,175,0,137,0,219,0,0,0,0,0,190,0,185,0,201,0,54,0,234,0,0,0,84,0,162,0,232,0,0,0,0,0,202,0,18,0,15,0,40,0,231,0,202,0,50,0,58,0,0,0,230,0,186,0,0,0,141,0,20,0,143,0,18,0,231,0,38,0,188,0,141,0,29,0,177,0,58,0,40,0,185,0,106,0,227,0,115,0,181,0,133,0,197,0,0,0,209,0,163,0);
signal scenario_full  : scenario_type := (53,31,116,31,98,31,201,31,201,30,201,29,111,31,111,30,196,31,161,31,25,31,229,31,229,30,49,31,104,31,104,30,149,31,212,31,212,30,152,31,143,31,163,31,59,31,161,31,161,30,108,31,146,31,67,31,67,30,184,31,50,31,109,31,94,31,229,31,84,31,84,30,243,31,145,31,132,31,211,31,104,31,104,30,104,29,191,31,43,31,28,31,246,31,6,31,249,31,32,31,200,31,202,31,87,31,27,31,67,31,67,30,67,29,200,31,163,31,8,31,201,31,49,31,187,31,187,30,110,31,110,30,125,31,70,31,76,31,249,31,23,31,162,31,237,31,96,31,60,31,60,30,4,31,203,31,230,31,124,31,100,31,199,31,177,31,79,31,155,31,190,31,190,30,85,31,148,31,152,31,3,31,226,31,238,31,48,31,69,31,57,31,57,30,57,29,57,28,176,31,73,31,39,31,124,31,120,31,245,31,153,31,165,31,45,31,85,31,67,31,245,31,245,30,240,31,203,31,193,31,192,31,225,31,186,31,9,31,100,31,205,31,205,30,224,31,89,31,248,31,51,31,6,31,63,31,134,31,6,31,136,31,113,31,207,31,207,30,207,29,1,31,11,31,77,31,143,31,234,31,6,31,38,31,38,30,5,31,196,31,207,31,56,31,56,30,172,31,180,31,217,31,218,31,133,31,36,31,201,31,201,30,189,31,217,31,103,31,27,31,240,31,69,31,56,31,17,31,2,31,62,31,62,30,240,31,108,31,190,31,190,30,76,31,76,30,118,31,242,31,57,31,57,30,228,31,181,31,181,30,192,31,200,31,219,31,219,30,231,31,101,31,118,31,102,31,203,31,129,31,127,31,216,31,75,31,187,31,187,30,187,29,213,31,12,31,161,31,98,31,98,30,186,31,57,31,57,30,249,31,96,31,143,31,162,31,162,30,70,31,179,31,50,31,231,31,225,31,225,30,8,31,38,31,73,31,17,31,17,31,80,31,44,31,161,31,188,31,172,31,176,31,176,30,176,29,138,31,201,31,25,31,53,31,41,31,243,31,9,31,55,31,78,31,105,31,122,31,122,30,186,31,215,31,148,31,75,31,37,31,37,30,88,31,158,31,149,31,61,31,216,31,160,31,237,31,44,31,44,30,141,31,141,30,236,31,68,31,180,31,193,31,21,31,217,31,141,31,81,31,81,30,220,31,33,31,190,31,61,31,166,31,169,31,169,30,169,29,169,28,8,31,31,31,174,31,91,31,127,31,17,31,17,30,134,31,134,30,183,31,59,31,54,31,56,31,56,30,156,31,156,30,201,31,169,31,169,30,169,29,216,31,207,31,1,31,1,30,1,29,68,31,68,30,208,31,208,30,21,31,12,31,153,31,153,30,153,29,153,28,45,31,109,31,107,31,107,30,107,29,155,31,21,31,2,31,237,31,129,31,177,31,175,31,175,30,150,31,16,31,210,31,37,31,37,30,231,31,33,31,195,31,27,31,147,31,154,31,164,31,22,31,230,31,164,31,135,31,204,31,145,31,33,31,33,30,250,31,226,31,118,31,180,31,113,31,49,31,65,31,64,31,201,31,201,30,124,31,134,31,202,31,16,31,16,30,167,31,105,31,105,30,202,31,202,30,88,31,202,31,202,30,202,29,98,31,102,31,108,31,108,30,82,31,222,31,206,31,35,31,245,31,155,31,148,31,152,31,240,31,171,31,171,30,125,31,238,31,238,30,238,29,7,31,43,31,221,31,175,31,137,31,219,31,219,30,219,29,190,31,185,31,201,31,54,31,234,31,234,30,84,31,162,31,232,31,232,30,232,29,202,31,18,31,15,31,40,31,231,31,202,31,50,31,58,31,58,30,230,31,186,31,186,30,141,31,20,31,143,31,18,31,231,31,38,31,188,31,141,31,29,31,177,31,58,31,40,31,185,31,106,31,227,31,115,31,181,31,133,31,197,31,197,30,209,31,163,31);

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
