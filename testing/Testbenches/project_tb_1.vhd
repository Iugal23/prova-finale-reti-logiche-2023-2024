-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_1 is
end project_tb_1;

architecture project_tb_arch_1 of project_tb_1 is
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

constant SCENARIO_LENGTH : integer := 288;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (170,0,198,0,0,0,46,0,1,0,143,0,0,0,132,0,182,0,0,0,179,0,0,0,97,0,27,0,0,0,200,0,0,0,240,0,131,0,141,0,128,0,255,0,190,0,171,0,252,0,115,0,255,0,211,0,0,0,85,0,91,0,150,0,119,0,0,0,210,0,0,0,50,0,232,0,243,0,101,0,136,0,93,0,110,0,224,0,0,0,149,0,0,0,51,0,41,0,4,0,148,0,15,0,219,0,0,0,40,0,177,0,89,0,167,0,12,0,81,0,0,0,0,0,109,0,23,0,103,0,0,0,38,0,116,0,92,0,106,0,192,0,0,0,36,0,253,0,10,0,0,0,227,0,0,0,185,0,0,0,65,0,0,0,126,0,0,0,134,0,0,0,152,0,147,0,26,0,12,0,8,0,171,0,51,0,240,0,17,0,147,0,128,0,85,0,216,0,0,0,67,0,252,0,232,0,176,0,211,0,80,0,155,0,164,0,8,0,0,0,119,0,77,0,27,0,0,0,128,0,168,0,45,0,126,0,17,0,176,0,108,0,0,0,39,0,255,0,80,0,202,0,160,0,86,0,206,0,63,0,235,0,175,0,196,0,88,0,155,0,0,0,115,0,249,0,207,0,173,0,114,0,92,0,91,0,239,0,153,0,50,0,173,0,65,0,135,0,0,0,51,0,119,0,100,0,0,0,19,0,30,0,206,0,93,0,0,0,0,0,117,0,220,0,91,0,115,0,218,0,0,0,204,0,5,0,111,0,0,0,62,0,254,0,141,0,0,0,84,0,231,0,88,0,0,0,229,0,183,0,0,0,189,0,169,0,0,0,58,0,68,0,68,0,156,0,140,0,113,0,0,0,166,0,215,0,0,0,71,0,101,0,90,0,21,0,184,0,252,0,7,0,217,0,0,0,20,0,199,0,118,0,160,0,58,0,113,0,72,0,191,0,12,0,77,0,159,0,0,0,168,0,250,0,37,0,208,0,9,0,21,0,63,0,224,0,0,0,7,0,0,0,59,0,0,0,167,0,112,0,113,0,55,0,140,0,150,0,0,0,93,0,198,0,228,0,94,0,217,0,101,0,190,0,210,0,128,0,225,0,203,0,131,0,69,0,0,0,0,0,161,0,26,0,172,0,212,0,232,0,0,0,56,0,7,0,250,0,168,0,0,0,59,0,140,0,146,0,143,0,97,0,81,0,213,0,187,0,32,0,140,0,153,0,7,0,215,0,56,0,123,0,0,0,44,0,63,0,76,0,213,0,152,0,0,0,37,0,0,0,0,0,157,0,204,0);
signal scenario_full  : scenario_type := (170,31,198,31,198,30,46,31,1,31,143,31,143,30,132,31,182,31,182,30,179,31,179,30,97,31,27,31,27,30,200,31,200,30,240,31,131,31,141,31,128,31,255,31,190,31,171,31,252,31,115,31,255,31,211,31,211,30,85,31,91,31,150,31,119,31,119,30,210,31,210,30,50,31,232,31,243,31,101,31,136,31,93,31,110,31,224,31,224,30,149,31,149,30,51,31,41,31,4,31,148,31,15,31,219,31,219,30,40,31,177,31,89,31,167,31,12,31,81,31,81,30,81,29,109,31,23,31,103,31,103,30,38,31,116,31,92,31,106,31,192,31,192,30,36,31,253,31,10,31,10,30,227,31,227,30,185,31,185,30,65,31,65,30,126,31,126,30,134,31,134,30,152,31,147,31,26,31,12,31,8,31,171,31,51,31,240,31,17,31,147,31,128,31,85,31,216,31,216,30,67,31,252,31,232,31,176,31,211,31,80,31,155,31,164,31,8,31,8,30,119,31,77,31,27,31,27,30,128,31,168,31,45,31,126,31,17,31,176,31,108,31,108,30,39,31,255,31,80,31,202,31,160,31,86,31,206,31,63,31,235,31,175,31,196,31,88,31,155,31,155,30,115,31,249,31,207,31,173,31,114,31,92,31,91,31,239,31,153,31,50,31,173,31,65,31,135,31,135,30,51,31,119,31,100,31,100,30,19,31,30,31,206,31,93,31,93,30,93,29,117,31,220,31,91,31,115,31,218,31,218,30,204,31,5,31,111,31,111,30,62,31,254,31,141,31,141,30,84,31,231,31,88,31,88,30,229,31,183,31,183,30,189,31,169,31,169,30,58,31,68,31,68,31,156,31,140,31,113,31,113,30,166,31,215,31,215,30,71,31,101,31,90,31,21,31,184,31,252,31,7,31,217,31,217,30,20,31,199,31,118,31,160,31,58,31,113,31,72,31,191,31,12,31,77,31,159,31,159,30,168,31,250,31,37,31,208,31,9,31,21,31,63,31,224,31,224,30,7,31,7,30,59,31,59,30,167,31,112,31,113,31,55,31,140,31,150,31,150,30,93,31,198,31,228,31,94,31,217,31,101,31,190,31,210,31,128,31,225,31,203,31,131,31,69,31,69,30,69,29,161,31,26,31,172,31,212,31,232,31,232,30,56,31,7,31,250,31,168,31,168,30,59,31,140,31,146,31,143,31,97,31,81,31,213,31,187,31,32,31,140,31,153,31,7,31,215,31,56,31,123,31,123,30,44,31,63,31,76,31,213,31,152,31,152,30,37,31,37,30,37,29,157,31,204,31);

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
