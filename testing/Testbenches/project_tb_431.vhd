-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_431 is
end project_tb_431;

architecture project_tb_arch_431 of project_tb_431 is
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

constant SCENARIO_LENGTH : integer := 405;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (0,0,231,0,211,0,139,0,136,0,7,0,228,0,240,0,175,0,173,0,241,0,202,0,91,0,53,0,11,0,159,0,77,0,238,0,72,0,68,0,170,0,196,0,0,0,0,0,160,0,123,0,11,0,219,0,130,0,0,0,137,0,0,0,19,0,52,0,0,0,249,0,254,0,0,0,152,0,138,0,243,0,201,0,145,0,65,0,94,0,235,0,144,0,136,0,46,0,168,0,133,0,235,0,41,0,25,0,169,0,33,0,0,0,120,0,138,0,253,0,143,0,0,0,168,0,0,0,92,0,224,0,0,0,0,0,0,0,0,0,118,0,0,0,27,0,242,0,66,0,236,0,0,0,232,0,134,0,0,0,205,0,0,0,0,0,176,0,163,0,107,0,108,0,239,0,168,0,21,0,0,0,164,0,12,0,52,0,0,0,18,0,52,0,238,0,61,0,116,0,0,0,15,0,189,0,28,0,119,0,0,0,165,0,235,0,84,0,0,0,98,0,7,0,133,0,7,0,119,0,68,0,30,0,0,0,0,0,0,0,0,0,152,0,183,0,0,0,201,0,99,0,44,0,190,0,116,0,237,0,67,0,102,0,190,0,134,0,180,0,0,0,0,0,108,0,2,0,126,0,26,0,192,0,0,0,189,0,81,0,0,0,0,0,75,0,195,0,160,0,27,0,173,0,106,0,163,0,204,0,0,0,116,0,158,0,82,0,241,0,141,0,189,0,242,0,55,0,171,0,219,0,192,0,163,0,0,0,235,0,50,0,29,0,75,0,0,0,101,0,0,0,0,0,243,0,0,0,48,0,0,0,113,0,180,0,0,0,250,0,0,0,28,0,28,0,0,0,162,0,0,0,151,0,176,0,10,0,0,0,36,0,132,0,177,0,63,0,0,0,233,0,0,0,73,0,211,0,80,0,79,0,47,0,24,0,168,0,0,0,103,0,250,0,55,0,127,0,0,0,0,0,0,0,76,0,0,0,61,0,26,0,219,0,37,0,0,0,0,0,0,0,246,0,0,0,237,0,214,0,20,0,18,0,32,0,168,0,0,0,121,0,2,0,29,0,154,0,134,0,99,0,46,0,0,0,0,0,153,0,253,0,221,0,0,0,239,0,49,0,90,0,21,0,101,0,114,0,0,0,0,0,0,0,182,0,172,0,0,0,0,0,244,0,214,0,168,0,228,0,87,0,0,0,5,0,0,0,21,0,0,0,168,0,163,0,234,0,211,0,0,0,0,0,0,0,126,0,140,0,255,0,0,0,4,0,0,0,58,0,13,0,230,0,22,0,134,0,0,0,0,0,200,0,34,0,8,0,112,0,0,0,174,0,0,0,148,0,106,0,0,0,0,0,0,0,146,0,0,0,104,0,207,0,56,0,144,0,0,0,104,0,185,0,56,0,132,0,66,0,105,0,95,0,83,0,206,0,206,0,159,0,137,0,174,0,0,0,0,0,138,0,57,0,216,0,0,0,0,0,142,0,0,0,9,0,15,0,71,0,1,0,0,0,60,0,213,0,140,0,0,0,9,0,191,0,0,0,99,0,155,0,194,0,135,0,0,0,78,0,67,0,102,0,199,0,195,0,0,0,0,0,186,0,234,0,231,0,0,0,187,0,194,0,0,0,0,0,128,0,100,0,101,0,4,0,153,0,4,0,84,0,59,0,237,0,104,0,163,0,141,0,234,0,12,0,173,0,0,0,0,0,24,0,106,0,137,0,220,0,0,0,179,0,192,0,79,0,5,0,35,0,0,0,214,0,179,0,86,0,94,0,0,0,194,0,232,0,197,0,249,0,0,0,119,0,106,0,229,0);
signal scenario_full  : scenario_type := (0,0,231,31,211,31,139,31,136,31,7,31,228,31,240,31,175,31,173,31,241,31,202,31,91,31,53,31,11,31,159,31,77,31,238,31,72,31,68,31,170,31,196,31,196,30,196,29,160,31,123,31,11,31,219,31,130,31,130,30,137,31,137,30,19,31,52,31,52,30,249,31,254,31,254,30,152,31,138,31,243,31,201,31,145,31,65,31,94,31,235,31,144,31,136,31,46,31,168,31,133,31,235,31,41,31,25,31,169,31,33,31,33,30,120,31,138,31,253,31,143,31,143,30,168,31,168,30,92,31,224,31,224,30,224,29,224,28,224,27,118,31,118,30,27,31,242,31,66,31,236,31,236,30,232,31,134,31,134,30,205,31,205,30,205,29,176,31,163,31,107,31,108,31,239,31,168,31,21,31,21,30,164,31,12,31,52,31,52,30,18,31,52,31,238,31,61,31,116,31,116,30,15,31,189,31,28,31,119,31,119,30,165,31,235,31,84,31,84,30,98,31,7,31,133,31,7,31,119,31,68,31,30,31,30,30,30,29,30,28,30,27,152,31,183,31,183,30,201,31,99,31,44,31,190,31,116,31,237,31,67,31,102,31,190,31,134,31,180,31,180,30,180,29,108,31,2,31,126,31,26,31,192,31,192,30,189,31,81,31,81,30,81,29,75,31,195,31,160,31,27,31,173,31,106,31,163,31,204,31,204,30,116,31,158,31,82,31,241,31,141,31,189,31,242,31,55,31,171,31,219,31,192,31,163,31,163,30,235,31,50,31,29,31,75,31,75,30,101,31,101,30,101,29,243,31,243,30,48,31,48,30,113,31,180,31,180,30,250,31,250,30,28,31,28,31,28,30,162,31,162,30,151,31,176,31,10,31,10,30,36,31,132,31,177,31,63,31,63,30,233,31,233,30,73,31,211,31,80,31,79,31,47,31,24,31,168,31,168,30,103,31,250,31,55,31,127,31,127,30,127,29,127,28,76,31,76,30,61,31,26,31,219,31,37,31,37,30,37,29,37,28,246,31,246,30,237,31,214,31,20,31,18,31,32,31,168,31,168,30,121,31,2,31,29,31,154,31,134,31,99,31,46,31,46,30,46,29,153,31,253,31,221,31,221,30,239,31,49,31,90,31,21,31,101,31,114,31,114,30,114,29,114,28,182,31,172,31,172,30,172,29,244,31,214,31,168,31,228,31,87,31,87,30,5,31,5,30,21,31,21,30,168,31,163,31,234,31,211,31,211,30,211,29,211,28,126,31,140,31,255,31,255,30,4,31,4,30,58,31,13,31,230,31,22,31,134,31,134,30,134,29,200,31,34,31,8,31,112,31,112,30,174,31,174,30,148,31,106,31,106,30,106,29,106,28,146,31,146,30,104,31,207,31,56,31,144,31,144,30,104,31,185,31,56,31,132,31,66,31,105,31,95,31,83,31,206,31,206,31,159,31,137,31,174,31,174,30,174,29,138,31,57,31,216,31,216,30,216,29,142,31,142,30,9,31,15,31,71,31,1,31,1,30,60,31,213,31,140,31,140,30,9,31,191,31,191,30,99,31,155,31,194,31,135,31,135,30,78,31,67,31,102,31,199,31,195,31,195,30,195,29,186,31,234,31,231,31,231,30,187,31,194,31,194,30,194,29,128,31,100,31,101,31,4,31,153,31,4,31,84,31,59,31,237,31,104,31,163,31,141,31,234,31,12,31,173,31,173,30,173,29,24,31,106,31,137,31,220,31,220,30,179,31,192,31,79,31,5,31,35,31,35,30,214,31,179,31,86,31,94,31,94,30,194,31,232,31,197,31,249,31,249,30,119,31,106,31,229,31);

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
